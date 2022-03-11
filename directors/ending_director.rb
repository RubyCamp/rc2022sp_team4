require_relative 'base'

module Directors
  # エンディング画面用ディレクター
  class EndingDirector < Base
    # 初期化
    def initialize(screen_width:, screen_height:, renderer:)
      super
      @create_ending_object = create_ending_object
    end

    def create_ending_object()
      flag = true
      lambda do
        return if flag == false 
        flag = false
        # FINISHの文字のアニメーションパネル生成
        @description = AnimatedPanel.new(width: 1, height: 0.25, start_frame: 15, map: TextureFactory.create_ending_description)
        @description.mesh.position.z = -0.5
        @description.mesh.position.y = 0.2
        self.scene.add(@description.mesh)

        # SCOREの文字のアニメーションパネル生成
        @description2 = AnimatedPanel.new(width: 0.25, height: 0.125, map: TextureFactory.create_ending_description_score)
        @description2.mesh.position.z = -0.5
        self.scene.add(@description2.mesh)

        # S(秒)の文字のアニメーションパネル生成
        @description3 = AnimatedPanel.new(map: TextureFactory.create_ending_second)
        @description3.mesh.position.z = -0.5
        @description3.mesh.position.x = 0.2
        @description3.mesh.position.y = -0.2
        self.scene.add(@description3.mesh)

        start_x = -0.1

        # 秒数を最大3桁まで表示させるもの
        ('%03d' % @@exec_time.to_i).chars.each_with_index do |char, idx|
          create_ending_score(char, start_x + (idx * 0.1), idx * 2)
        end
      end
    end

    def create_ending_score(char, x_pos, delay_frames)
      panel = AnimatedPanel.new(start_frame: 30, map: TextureFactory.create_score(char))
      panel.mesh.position.x = x_pos
      panel.mesh.position.z = -0.5
      panel.mesh.position.y = -0.15
      self.scene.add(panel.mesh)
      @panels ||= []
      @panels << panel
    end

    # 1フレーム分の進行処理
    def play
      # テキスト表示用パネルを一度だけ生成する
      @create_ending_object.call

      # テキスト表示用パネルを1フレーム分アニメーションさせる
      @description.play
      @description2.play
      @description3.play
      @panels.each(&:play)
    end

    # キー押下（単発）時のハンドリング
    def on_key_pressed(glfw_key:)
      case glfw_key
      # ESCキー押下で終了する
      when GLFW_KEY_ESCAPE
        puts 'クリア!!'
        transition_to_next_director # self.next_directorがセットされていないのでメインループが終わる
      when GLFW_KEY_BACKSPACE
        puts 'クリア!! replay!'
        self.next_director = Directors::TitleDirector.new(screen_width: self.renderer.width, screen_height: self.renderer.height, renderer: self.renderer)
        transition_to_next_director
      end
    end
  end
end
