# game_directorからカメラ(照準)変更用関数が呼ばれる
class MoveCamera
  SIGHT_SPEED = 0.1
  @camera_move_count = 0
  
  def self.sun_camera_left(_, sight)
    p 'sun_camera_left'
    # 照準の行動制限
    if sight.position.z >= 9.5
      return sight.position.z
    end
    sight.position.z += SIGHT_SPEED 
  end

  def self.sun_camera_right(_, sight)
    p 'sun_camera_right'
    # 照準の行動制限
    if sight.position.z <= -9.5
      return sight.position.z
    end
    sight.position.z -= SIGHT_SPEED
  end

  def self.sun_camera_up(_, sight)
    p 'sun_camera_up'
    # 照準の行動制限
    if sight.position.x >= 7
      return sight.position.x
    end
    sight.position.x += SIGHT_SPEED
  end

  def self.sun_camera_down(_, sight)
    p 'sun_camera_down'
    # 照準の行動制限
    if sight.position.x <= -7
      return sight.position.x
    end
    sight.position.x -= SIGHT_SPEED
  end

  def self.revol_camera_left(camera, sight)
    @camera_move_count += 1
    camera.position.x = Directors::GameDirector::CAMERA_REVOLUTION * Math.sin(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_X)
    camera.position.z = Directors::GameDirector::CAMERA_REVOLUTION * Math.cos(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_Y)
    camera.look_at(Mittsu::Vector3.new(0, 2, 0))
    # sight.position = camera.position.clone.normalize.tap do |pos|
    #   pos.x *= -Earth::DISTANCE
    #   pos.z *= -Earth::DISTANCE
    #   pos.y = sight.position.y
    # end # カメラの向かい側
    sight.position.z += SIGHT_SPEED
  end

  def self.revol_camera_right(camera, sight)
    @camera_move_count -= 1
    camera.position.x = Directors::GameDirector::CAMERA_REVOLUTION * Math.sin(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_X)
    camera.position.z = Directors::GameDirector::CAMERA_REVOLUTION * Math.cos(@camera_move_count * Directors::GameDirector::CAMERA_ROTATE_SPEED_Y)
    camera.look_at(Mittsu::Vector3.new(0, 2, 0))
    # sight.position = camera.position.clone.normalize.tap do |pos|
    #   pos.x *= -Earth::DISTANCE
    #   pos.z *= -Earth::DISTANCE
    #   pos.y = sight.position.y
    # end # カメラの向かい側
    sight.position.x -= SIGHT_SPEED
  end

  def self.revol_camera_up(_, sight)
    sight.position.z += SIGHT_SPEED
  end

  def self.revol_camera_down(_, sight)
    sight.position.z -= SIGHT_SPEED
  end
end
