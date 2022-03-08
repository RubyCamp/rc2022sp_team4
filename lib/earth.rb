# 地球
class Earth
  attr_accessor :mesh

  DISTANCE = 3.5

  # 初期化
  # 進行方向を表す単位ベクトルを受領する
  def initialize
    # 今何radのところにいるか
    self.mesh = MeshFactory.create_earth
    self.mesh.position.set(0, 8, 0)
    @forwarded_frame_count = 0 # 何フレーム分進行したかを記憶するカウンタ
  end

  # メッシュの現在位置を返す
  # def position
  #   self.mesh.position
  # end

  # １フレーム分の進行処理
  def play(speed_level: 1)
    self.mesh.position.x = DISTANCE * Math.sin(@forwarded_frame_count * speed_level / 5.0 * 0.1)
    self.mesh.position.z = DISTANCE * Math.cos(@forwarded_frame_count * speed_level / 5.0 * 0.1)
    @forwarded_frame_count += 1
  end
end
