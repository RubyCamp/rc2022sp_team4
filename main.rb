require 'mittsu'

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, 1.333, 0.1, 1000.0)
renderer = Mittsu::OpenGLRenderer.new width: 800, height: 600, title: 'RubyCamp 2022'

geometry = Mittsu::BoxGeometry.new(1.0, 1.0, 1.0)
material = Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
mesh = Mittsu::Mesh.new(geometry, material)
mesh.position.z = -5
scene.add(mesh)

renderer.window.run do
  mesh.rotation.x += 0.05
  renderer.render(scene, camera)
end