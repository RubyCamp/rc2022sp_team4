# game_directorからカメラ(照準)変更用関数が呼ばれる
class MoveCamera
  # 仮引数の_は使わないという意味、このコメントは削除して下さい
  def self.sun_camera_left(_, sight)
    p 'sun_camera_left'
  end

  def self.sun_camera_right(_, sight)
    p 'sun_camera_right'
  end

  def self.sun_camera_up(_, sight)
    p 'sun_camera_up'
  end

  def self.sun_camera_down(_, sight)
    p 'sun_camera_down'
  end

  def self.revol_camera_left(camera, _)
    # camera.position.x = 1 # 今使われているcameraが渡されている、削除して下さい
    p 'revol_camera_left'
  end

  def self.revol_camera_right(camera, _)
    p 'revol_camera_right'
  end

  def self.revol_camera_up(_, sight)
    p 'revol_camera_up'
  end

  def self.revol_camera_down(_, sight)
    p 'revol_camera_down'
  end
end
