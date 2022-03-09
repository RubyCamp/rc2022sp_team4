# 敵キャラクタ
class Enemy
  attr_accessor :mesh, :expired
  FRAME_COUNT_UPPER_LIMIT = 10 * 60

  # 初期化
  def initialize(x: nil, y: nil, z: nil, revol_radius:)
    # 初期位置指定が無ければランダムに配置する
    x ||= rand(10) / 10.0 - 0.5
    y ||= 20
    z ||= rand(10) / 10.0 - 0.5
    pos = Mittsu::Vector3.new(x, y, -z)
    self.mesh = MeshFactory.create_enemy(r: 0.2, color: 0x00ff00)
    self.mesh.position = pos
    @speed = 0.1
    @time = (y - 8) / @speed
    @vector_x = (revol_radius * Math.sin(rand * 2 * Math::PI) - x) / @time
    @vector_z = (revol_radius * Math.cos(rand * 2 * Math::PI) - z) / @time
    @forwarded_frame_count = 0 # 何フレーム分進行したかを記憶するカウンタ
    self.expired = false
  end

  # メッシュの現在位置を返す
  def position
    self.mesh.position
  end

  # 1フレーム分の進行処理
  def play
    self.mesh.position.x -= @vector_x
    self.mesh.position.y -= @speed
    self.mesh.position.z -= @vector_z

    @forwarded_frame_count += 1

    # 進行フレーム数が上限に達したら消滅フラグを立てる
    if @forwarded_frame_count > FRAME_COUNT_UPPER_LIMIT
      self.expired = true
    end
  end
end
