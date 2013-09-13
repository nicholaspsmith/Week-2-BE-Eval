module Tennis
  class Game
    attr_accessor :player1, :player2

    def initialize
      @player1 = Player.new
      @player2 = Player.new

      @player1.opponent = @player2
      @player2.opponent = @player1
    end

    def wins_ball(player,num)
      player.record_won_ball!
    end
  end

  class Player
    attr_accessor :points, :opponent

    def initialize
      @points = 0
      @score = ['love','fifteen','thirty','forty']
      @deuce = false
      @advantage = false
    end

    # Increments the score by 1.
    #
    # Returns the integer new score.
    def record_won_ball!
      @points += 1
    end

    # Returns the String score for the player.
    def score
      @score[@points]
    end
  end
end