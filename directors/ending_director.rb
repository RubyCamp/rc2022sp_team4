require_relative 'base'

module Directors
  # エンディング画面用ディレクター
  class EndingDirector < Base
    # 初期化
    def initialize(screen_width:, screen_height:, renderer:)
      super

      # ゲーム開始時刻の設定
      @time_now = Time.now

      create_ending_object
    end

    def create_ending_object()
      @description = AnimatedPanel.new(width: 1, height: 0.25, start_frame: 15, map: TextureFactory.create_ending_description)
      @description.mesh.position.z = -0.5
      @description.mesh.position.y = 0.2
      self.scene.add(@description.mesh)

      start_x = -0.1
      p exec_time = Time.now - @time_now

      %w(9 9 9).each_with_index do |char, idx|
        create_ending_score(char, start_x + (idx * 0.1), idx * 2)
      end
    end

    def create_ending_score(char, x_pos, delay_frames)
      panel = AnimatedPanel.new(start_frame: 30, map: TextureFactory.create_score(char))
      panel.mesh.position.x = x_pos
      panel.mesh.position.z = -0.5
      self.scene.add(panel.mesh)
      @panels ||= []
      @panels << panel
    end

    # 1フレーム分の進行処理
    def play
      # テキスト表示用パネルを1フレーム分アニメーションさせる
      @description.play

      @panels.each(&:play)
    end

    # キー押下（単発）時のハンドリング
    def on_key_pressed(glfw_key:)
      case glfw_key
      # ESCキー押下で終了する
      when GLFW_KEY_ESCAPE
        puts 'クリア!!'
        transition_to_next_director # self.next_directorがセットされていないのでメインループが終わる
      end
    end
  end
end
