# 地球
class Earth
  attr_accessor :mesh

  REVOL_RADIUS = 3.5
  DEFAULT_POSITION_Y = 8

  # 初期化
  # 進行方向を表す単位ベクトルを受領する
  def initialize
    # 今何radのところにいるか
    self.mesh = MeshFactory.create_earth
    self.mesh.position.set(0, DEFAULT_POSITION_Y, 0)
    @forwarded_move_count = 0 # 何マス進行したかを記憶する
  end

  # メッシュの現在位置を返す
  def position
    self.mesh.position
  end

  # 公転
  def revolution(speed_level: 1)
    self.mesh.position.x = REVOL_RADIUS * Math.sin(@forwarded_move_count * speed_level / 5.0 * 0.1)
    self.mesh.position.z = REVOL_RADIUS * Math.cos(@forwarded_move_count * speed_level / 5.0 * 0.1)
    @forwarded_move_count += 1
  end

  # 地球の自転
  def spin
    self.mesh.rotate_x(0.1)
    self.mesh.rotate_y(0.1)
    self.mesh.rotate_z(0.1)
  end

   # 地球の自転
   def spin
    #self.mesh.rotate_x(0.1)
    #self.mesh.rotate_y(0.1)
    self.mesh.rotate_z(0.1)
  end
  
end
