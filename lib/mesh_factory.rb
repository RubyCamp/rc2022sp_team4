# メッシュオブジェクトのファクトリー
# ゲーム内に登場するメッシュを生産する役割を一手に引き受ける
class MeshFactory
  # 弾丸の生成
  def self.create_bullet(r: 0.5, div_w: 16, div_h: 16, color: nil, map: nil, normal_map: nil)
    geometry = Mittsu::SphereGeometry.new(r, div_w, div_h)
    material = generate_material(
      :basic,
      nil,
      TextureFactory.create_texture_map('sun.png'),
      nil
    )
    Mittsu::Mesh.new(geometry, material)
  end

  # 敵キャラクタ(隕石)の生成
  def self.create_enemy(r: 0.5, div_w: 16, div_h: 16, color: nil, map: nil, normal_map: nil)
    geometry = Mittsu::SphereGeometry.new(r, div_w, div_h)
    material = generate_material(
      :basic,
      nil,
      TextureFactory.create_texture_map('meteo.png'),
      nil
    )
    Mittsu::Mesh.new(geometry, material)
  end

  # 平面パネルの生成
  def self.create_panel(width: 1, height: 1, color: nil, map: nil)
    geometry = Mittsu::PlaneGeometry.new(width, height)
    material = generate_material(:basic, color, map, nil)
    Mittsu::Mesh.new(geometry, material)
  end

  # 地球の生成
  def self.create_earth
    geometry = Mittsu::SphereGeometry.new(1, 64, 64)
    material = generate_material(
      :phong,
      nil,
      TextureFactory.create_texture_map('earth.png'),
      TextureFactory.create_normal_map('earth_normal.png')
    )
    Mittsu::Mesh.new(geometry, material)
  end

  # 太陽の生成
  def self.create_sun
    geometry = Mittsu::SphereGeometry.new(5, 64, 64)
    material = generate_material(
      :basic,
      nil,
      TextureFactory.create_texture_map('sun_cream.png'),
      nil
    )
    Mittsu::Mesh.new(geometry, material)
  end

  # 軌道の生成
  def self.create_revol
    geometry = Mittsu::RingGeometry.new(Earth::DISTANCE - 0.05, Earth::DISTANCE + 0.05, 32, 4)
    material = Mittsu::MeshBasicMaterial.new(color: 0x333333)
    Mittsu::Mesh.new(geometry, material)
  end

  # 照準の生成
  def self.create_sight
    geometry = Mittsu::RingGeometry.new(0.2, 0.4, 16, 4)
    material = Mittsu::MeshBasicMaterial.new(color: 0xff0000)
    Mittsu::Mesh.new(geometry, material)
  end

  # 汎用マテリアル生成メソッド
  def self.generate_material(type, color, map, normal_map)
    mat = nil
    args = {}
    args[:color] = color if color
    args[:map] = map if map
    args[:normal_map] = normal_map if normal_map
    case type
    when :basic
      mat = Mittsu::MeshBasicMaterial.new(args)

    when :lambert
      mat = Mittsu::MeshLambertMaterial.new(args)

    when :phong
      mat = Mittsu::MeshPhongMaterial.new(args)
    end
    mat
  end
end
