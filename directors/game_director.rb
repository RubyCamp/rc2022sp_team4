require_relative 'base'
# require_relative '../lib/move_camera'

module Directors
  # ゲーム本編のディレクター
  class GameDirector < Base
    CAMERA_ROTATE_SPEED_X = 0.01
    CAMERA_ROTATE_SPEED_Y = 0.01
    CAMERA_REVOLUTION = 15

    # 初期化
    def initialize(screen_width:, screen_height:, renderer:)
      super

      # ゲーム本編の次に遷移するシーンのディレクターオブジェクトを用意
      self.next_director = EndingDirector.new(screen_width: screen_width, screen_height: screen_height, renderer: renderer)

      # 弾丸の詰め合わせ用配列
      @bullets = []

      # 敵の詰め合わせ用配列
      @enemies = []

      # 現在のフレーム数をカウントする
      @frame_counter = 0

      @camera_rotate_x = 0.0
      @camera_rotate_y = 0.0

      # 公転カメラと太陽カメラ
      @camera_keys = %i[sun_camera revol_camera]
      @cameras = { sun_camera: Mittsu::PerspectiveCamera.new(self.camera.fov, self.camera.aspect, 0.1, 1000.0).tap do
        |cmr|
        cmr.position.set(0, -2, 0)
        # 移動後のカメラ位置から、原点（[0, 0, 0]）を注視し直す
        cmr.look_at(Mittsu::Vector3.new(0, 0, 0))
      end, revol_camera: self.camera }

      # 現在公転カメラ
      self.camera.position.set(0, 2, CAMERA_REVOLUTION)
      # 移動後のカメラ位置から、原点（[0, 0, 0]）を注視し直す
      self.camera.look_at(Mittsu::Vector3.new(0, 2, 0))

      # ゲーム本編の登場オブジェクト群を生成
      create_objects
    end

    # １フレーム分の進行処理
    def play
      # 地球を少しずつ回転させ、公転?してる雰囲気を醸し出す
      @earth.revolution(speed_level: 1)
      # ENTERキーでブースト
      @earth.revolution(speed_level: 1) if self.renderer.window.key_down?(GLFW_KEY_ENTER)

      # 現在発射済みの弾丸を一通り動かす
      @bullets.each(&:play)

      # 現在登場済みの敵を一通り動かす
      @enemies.each(&:play)

      # 各弾丸について当たり判定実施
      @bullets.each { |bullet| hit_any_enemies(bullet) }

      # 消滅済みの弾丸及び敵を配列とシーンから除去(わざと複雑っぽく記述しています)
      rejected_bullets = []
      @bullets.delete_if { |bullet| bullet.expired ? rejected_bullets << bullet : false }
      rejected_bullets.each { |bullet| self.scene.remove(bullet.mesh) }
      rejected_enemies = []
      @enemies.delete_if { |enemy| enemy.expired ? rejected_enemies << enemy : false }
      rejected_enemies.each { |enemy| self.scene.remove(enemy.mesh) }

      # 一定のフレーム数経過毎に敵キャラ(隕石)を出現させる
      if (@frame_counter % 10).zero?
        enemy = Enemy.new
        @enemies << enemy
        self.scene.add(enemy.mesh)
      end

      @frame_counter += 1

      # カメラ回転、照準器移動
      event_occur = %w[GLFW_KEY_Q GLFW_KEY_E GLFW_KEY_UP GLFW_KEY_DOWN GLFW_KEY_LEFT GLFW_KEY_RIGHT]
      event_occur.each do |key|
        MoveCamera.send(@camera_keys.first.to_s + key[8..].downcase, self.camera, @sight) if self.renderer.window.key_down?(eval(key))
      end
    end

    # キー押下（単発）時のハンドリング
    def on_key_pressed(glfw_key:)
      case glfw_key
      # ESCキー押下でエンディングに無理やり遷移
      when GLFW_KEY_ESCAPE
        puts 'シーン遷移 → EndingDirector'
        transition_to_next_director
      # SPACEキー押下で弾丸を発射
      when GLFW_KEY_SPACE
        shoot
      when GLFW_KEY_Z, GLFW_KEY_A
        p @camera_keys.first
        # 2要素だけだし、reverseで
        self.camera = @cameras[@camera_keys.reverse!.first]
        # rendererの再設定
        renderer.render(self.scene, self.camera)
      end
    end

    private

    # ゲーム本編の登場オブジェクト群を生成
    def create_objects
      # カメラの設定
      self.camera = @cameras[@camera_keys.first]

      # 太陽生成。
      @sun = MeshFactory.create_sun
      @sun.position.set(0, 0, 0)
      self.scene.add(@sun)

      # 太陽(光)をセット
      @sunlite = LightFactory.create_sun_light
      @sunlite.position.set(0, 0, 0)
      self.scene.add(@sunlite)

      # 地球を作成し、カメラ位置（原点）に対して大気圏を飛行してるっぽく見える位置に移動させる
      @earth = Earth.new
      self.scene.add(@earth.mesh)

      # 地球の公転軌道を描く
      revolution = MeshFactory.create_revol
      revolution.position.y = @earth.position.y
      revolution.rotation.x = Math::PI / 2.0
      self.scene.add(revolution)

      # 照準設定
      @sight = MeshFactory.create_sight
      @sight.rotation.x = Math::PI / 2.0
      @sight.position = self.camera.position.clone.normalize.tap do |pos|
        pos.x *= -Earth::REVOL_RADIUS
        pos.z *= -Earth::REVOL_RADIUS
        pos.y = @earth.position.y
      end
      self.scene.add(@sight)
    end

    # 弾丸発射
    def shoot
      # 現在カメラが向いている方向を進行方向とし、進行方向に対しBullet::SPEED分移動する単位単位ベクトルfを作成する
      # f = Mittsu::Vector4.new(0, 0, 1, 0)
      # f.apply_matrix4(self.camera.matrix).normalize
      # f.multiply_scalar(Bullet::SPEED)

      # 弾丸オブジェクト生成
      bullet = Bullet.new(@sight.position)
      self.scene.add(bullet.mesh)
      @bullets << bullet
    end

    # 弾丸と敵の当たり判定
    def hit_any_enemies(bullet)
      return if bullet.expired

      @enemies.each do |enemy|
        next if enemy.expired
        distance = bullet.position.distance_to(enemy.position)
        if distance < 0.8
          puts 'Hit!'
          bullet.expired = true
          enemy.expired = true
        end
      end
    end
  end
end