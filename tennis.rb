module Tennis
  class Game
    attr_accessor :player1, :player2

    def initialize
      @player1 = Player.new
      @player2 = Player.new

      @player1.opponent = @player2
      @player2.opponent = @player1
    end

    def wins_ball(num)
      if num == 1
        @player1.record_won_ball!
        if @player1.advantage
          @player1.win = true
          @player1.games_won += 1
        end
      elsif num == 2
        @player2.record_won_ball!
        if @player2.advantage
          @player2.win = true
          @player1.games_won += 1
        end
      end


      @player1.deuce = false
      @player2.deuce = false
      @player1.advantage = false
      @player2.advantage = false
      point1 = @player1.points
      point2 = @player2.points

      if point1 > 2 and point2 > 2
        if point1 == point2
          @player1.deuce = true
          @player2.deuce = true
        elsif point1 > point2
          @player1.advantage = true
        elsif point2 > point1
          @player2.advantage = true
        end
      end
    end
  end

  class Player
    attr_accessor :points, :opponent, :deuce, :advantage, :win, :games_won

    def initialize
      @points = 0
      @score = ['love','fifteen','thirty','forty']
      @deuce = false
      @advantage = false
      @win = false
      @games_won = 0
    end

    # Increments the score by 1.
    #
    # Returns the integer new score.
    def record_won_ball!
      @points += 1
    end

    # Returns the String score for the player.
    def score
      if (@deuce == false && @advantage == false)
        @score[@points]
      elsif @deuce
        'deuce'
      elsif @advantage
        'advantage'
      end
        
    end
  end
end