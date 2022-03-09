# game_directorからカメラ(照準)変更用関数が呼ばれる
class MoveCamera
  @camera_move_count = 0
  # 仮引数の_は使わないという意味、このコメントは削除して下さい
  def self.sun_camera_left(_, sight)
    p 'sun_camera_left'
    sight.position.x += 1 
  end

  def self.sun_camera_right(_, sight)
    p 'sun_camera_right'
    sight.position.x -= 1 
  end

  def self.sun_camera_up(_, sight)
    p 'sun_camera_up'
    sight.position.z += 1 
  end

  def self.sun_camera_down(_, sight)
    p 'sun_camera_down'
    sight.position.z -= 1 
  end

  def self.revol_camera_left(camera, _)
    # camera.position.x = 1 # 今使われているcameraが渡されている、削除して下さい
    p 'revol_camera_left'
    @camera_move_count += 1
    camera.position.x = Directors::GameDirector::CAMERA_REVOLUTION * Math.sin(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_X)
    camera.position.z = Directors::GameDirector::CAMERA_REVOLUTION * Math.cos(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_Y)
    camera.look_at(Mittsu::Vector3.new(0, 2, 0))
  end

  def self.revol_camera_right(camera, _)
    p 'revol_camera_right'
    @camera_move_count -= 1
    camera.position.x = Directors::GameDirector::CAMERA_REVOLUTION * Math.sin(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_X)
    camera.position.z = Directors::GameDirector::CAMERA_REVOLUTION * Math.cos(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_Y)
    camera.look_at(Mittsu::Vector3.new(0, 2, 0))
  end

  def self.revol_camera_up(_, sight)
    p 'revol_camera_up'
  end

  def self.revol_camera_down(_, sight)
    p 'revol_camera_down'
  end
end
