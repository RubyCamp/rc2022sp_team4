SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768
ASPECT_RATIO = SCREEN_WIDTH / SCREEN_HEIGHT.to_f

# タイトル画面の登場オブジェクト群を生成
def create_objects
    # 太陽光をセット
    @sun = LightFactory.create_sun_light
    self.scene.add(@sun)

    # 背景用の地球を作成
    @earth = MeshFactory.create_earth
    @earth.position.z = -2
    self.scene.add(@earth)
end