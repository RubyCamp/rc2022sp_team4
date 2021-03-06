require_relative 'base'

module Directors
  # タイトル画面用ディレクター
  class TitleDirector < Base
    # 初期化
    def initialize(screen_width:, screen_height:, renderer:)
      super

      # タイトル画面の次に遷移するシーンのディレクターオブジェクトを用意
      self.next_director = GameDirector.new(screen_width: screen_width, screen_height: screen_height, renderer: renderer)

      # タイトル画面の登場オブジェクト群を生成
      create_objects
    end

    # １フレーム分の進行処理
    def play
      # # 地球を斜め方向に回転させる
      @earth.rotate_x(0.001)
      @earth.rotate_y(0.001)

      # タイトル文字パネル群をそれぞれ１フレーム分進行させる
      # @panels.each(&:play)

      # 説明用文字パネルを１フレーム分進行させる

      @description.play
      @description2.play
    end

    # キー押下（単発）時のハンドリング
    def on_key_pressed(glfw_key:)
      case glfw_key
      # SPACEキー押下で弾丸を発射
      when GLFW_KEY_SPACE
        puts 'シーン遷移 → GameDirector'
        @@start_time = Time.now
        @@game_kind = :normal
        transition_to_next_director
      # ENTERキー押下で地球に当てるとダメにする
      when GLFW_KEY_ENTER
        puts 'シーン遷移 → GameDirector(Don\'t shoot to the Earth)'
        @@start_time = Time.now
        @@game_kind = :shoot_earth
        transition_to_next_director
      # SHIFTキー押下で特大弾丸発射(クールタイムあり)
      when GLFW_KEY_RIGHT_SHIFT, GLFW_KEY_LEFT_SHIFT
        puts 'シーン遷移 → GameDirector(Can\'t always use shoot method)'
        @@start_time = Time.now
        @@game_kind = :cool_time_shoot
        transition_to_next_director
      end
    end

    private

    # タイトル画面の登場オブジェクト群を生成
    def create_objects
      # 太陽光をセット
      @sun = LightFactory.create_sun_light
      self.scene.add(@sun)

      # 背景用の地球を作成
      @earth = MeshFactory.create_earth
      @earth.position.z = -2
      self.scene.add(@earth)

      # タイトル文字パネルの初期表示位置（X座標）を定義
      # start_x = -0.35

      # RubyCampの8文字を、1文字1アニメーションパネルとして作成し、表示開始タイミングを微妙にずらす
      # %w[R u b y C a m p].each_with_index do |char, idx|
      #   create_title_logo(char, start_x + (idx * 0.1), idx * 2)
      # end

      # 説明文字列用のパネル作成
      # タイトル画面表示開始から180フレーム経過で表示するように調整
      # 位置は適当に決め打ち
      @description = AnimatedPanel.new(width: 0.30, height: 0.25, start_frame: 90, map: TextureFactory.create_title_description)
      @description.mesh.position.y = 0.1
      @description.mesh.position.z = -0.5
      self.scene.add(@description.mesh)

      @description2 = Panel.new(width: 1, height: 0.25, start_frame: 0, map: TextureFactory.create_press_button)
      @description2.mesh.position.y = -0.2
      @description2.mesh.position.z = -0.5
      self.scene.add(@description2.mesh)

      # self.scene.remove(@description2.mesh)

      # until GLFW_KEY_SPACE do
      #   if  @frame_counter >=1
      #     self.scene.add(@description2.mesh)
      #     elsif  @frame_counter >= 180
      #     self.scene.remove(@description2.mesh)
      #     elsif  @frame_counter >= 360
      #     @frame_counter = 0
      #   end
      # end
      # @description3 = Panel.new(width: 1, height: 0.25, start_frame: , map: TextureFactory.create_press_button2)
      # @description3.mesh.position.y = -0.2
      # @description3.mesh.position.z = -0.5
      # self.scene.add(@description3.mesh)
    end

    # タイトルロゴ用アニメーションパネル作成
    # タイトル画面の表示開始から30+delay_framesのフレームが経過してから、120フレーム掛けてアニメーションするよう設定
    # def create_title_logo(char, x_pos, delay_frames)
    #   panel = AnimatedPanel.new(start_frame: 30 + delay_frames, duration: 120, map: TextureFactory.create_string(char))
    #   panel.mesh.position.x = x_pos
    #   panel.mesh.position.z = -0.5
    #   self.scene.add(panel.mesh)
    #   @panels ||= []
    #   @panels << panel
    # end
  end
end
