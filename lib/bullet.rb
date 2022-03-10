# 弾丸モデル
class Bullet
  attr_accessor :mesh, :expired

  SPEED = -0.05 # 弾丸の速度
  FRAME_COUNT_UPPER_LIMIT = 3 * 60

  # 初期化
  # 進行方向を表す単位ベクトルを受領する
  def initialize(sight_pos)
    self.mesh = MeshFactory.create_bullet(r: 0.02, color: 0xff0000)
    x = y = z = 0
    pos = Mittsu::Vector3.new(x, y, z)
    self.mesh.position = pos
    @speed = 0.1
    @time = 8 / @speed
    @vector_x = (sight_pos.pos.x - x) / @time
    @vector_z = (revol_radius * Math.cos(rand * 2 * Math::PI) - z) / @time

    @forward_vector = sight_pos
    @forwarded_frame_count = 0 # 何フレーム分進行したかを記憶するカウンタ
    self.expired = false
  end

  # メッシュの現在位置を返す
  def position
    self.mesh.position
  end

  # １フレーム分の進行処理
  def play
    # オブジェクト生成時に渡された進行方向に向けて、単位ベクトル分だけ進む
    self.mesh.position.add(@forward_vector)

    @forwarded_frame_count += 1

    # 進行フレーム数が上限に達したら消滅フラグを立てる
    if @forwarded_frame_count > FRAME_COUNT_UPPER_LIMIT
      self.expired = true
    end
  end
end
