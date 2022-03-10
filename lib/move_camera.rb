# game_directorからカメラ(照準)変更用関数が呼ばれる
class MoveCamera
  SIGHT_SPEED = 0.1
  @camera_move_count = 0

  def self.sun_camera_left(_, sight)
    return if sight.position.z >= 9.5
    sight.position.z += SIGHT_SPEED
  end

  def self.sun_camera_right(_, sight)
    return if sight.position.z <= -9.5
    sight.position.z -= SIGHT_SPEED
  end

  def self.sun_camera_up(_, sight)
    return if sight.position.x >= 7
    sight.position.x += SIGHT_SPEED
  end

  def self.sun_camera_down(_, sight)
    return if sight.position.x <= -7
    sight.position.x -= SIGHT_SPEED
  end

  def self.sun_camera_q(_, sight)
  end

  def self.sun_camera_e(_, sight)
  end

  def self.revol_camera_left(_, sight)
    return if sight.position.z >= 9.5
    sight.position.z += SIGHT_SPEED
  end

  def self.revol_camera_right(_, sight)
    return if sight.position.z <= -9.5
    sight.position.z -= SIGHT_SPEED
  end

  def self.revol_camera_up(_, sight)
    return if sight.position.x >= 7
    sight.position.x += SIGHT_SPEED
  end

  def self.revol_camera_down(_, sight)
    return if sight.position.x <= -7
    sight.position.x -= SIGHT_SPEED
  end

  def self.revol_camera_q(camera, _)
    @camera_move_count -= 1
    camera.position.x = Directors::GameDirector::CAMERA_REVOLUTION * Math.sin(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_X)
    camera.position.z = Directors::GameDirector::CAMERA_REVOLUTION * Math.cos(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_Y)
    camera.look_at(Mittsu::Vector3.new(0, 2, 0))
  end

  def self.revol_camera_e(camera, _)
    @camera_move_count += 1
    camera.position.x = Directors::GameDirector::CAMERA_REVOLUTION * Math.sin(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_X)
    camera.position.z = Directors::GameDirector::CAMERA_REVOLUTION * Math.cos(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_Y)
    camera.look_at(Mittsu::Vector3.new(0, 2, 0))
  end
end
