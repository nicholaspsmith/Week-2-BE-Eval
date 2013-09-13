require 'rubygems'
require 'bundler/setup'
require 'rspec'
require_relative '../tennis'

describe Tennis::Game do
  let(:game) { Tennis::Game.new }

  describe '.initialize' do
    it 'creates two players' do
      expect(game.player1).to be_a(Tennis::Player)
      expect(game.player2).to be_a(Tennis::Player)
    end

    it 'sets the opponent for each player' do
      p1 = game.player1
      p2 = game.player2
      p1.opponent = p2
      p2.opponent = p1

      expect(p1.opponent).to eq(p2)
      expect(p2.opponent).to eq(p1)
    end
  end

  describe '#wins_ball' do
    it 'increments the points of the winning player' do
      p1 = game.player1
      game.wins_ball(1)

      expect(p1.points).to eq(1)
    end
  end
end

describe Tennis::Player do
  let(:player) do
    player = Tennis::Player.new
    player.opponent = Tennis::Player.new

    return player
  end

  describe '.initialize' do
    it 'sets the points to 0' do
      expect(player.points).to eq(0)
    end 
  end

  describe '#record_won_ball!' do
    it 'increments the points' do
      player.record_won_ball!

      expect(player.points).to eq(1)
    end
  end

  describe '#score' do
    context 'when points is 0' do
      it 'returns love' do
        expect(player.score).to eq('love')
      end
    end
    
    context 'when points is 1' do
      it 'returns fifteen' do
        player.points = 1

        expect(player.score).to eq('fifteen')
      end 
    end
    
    context 'when points is 2' do
      it 'returns thirty' do
        player.points = 2

        expect(player.score).to eq('thirty')
      end
    end
    
    context 'when points is 3' do
      it 'returns forty' do
        player.points = 3

        expect(player.score).to eq('forty')
      end
    end

    context "when points is 3 for each player" do
      it "returns deuce" do
        game = Tennis::Game.new
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)
        game.wins_ball(2)

        expect(game.player1.score).to eq('deuce')
      end
    end

    context "when player1 has 4 and player2 has 3" do
      it "player1.score returns advantage" do
        game = Tennis::Game.new
        game.wins_ball(1)#1
        game.wins_ball(2)#1
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)#3
        game.wins_ball(2)#3
        game.wins_ball(1)#4

        expect(game.player1.score).to eq('advantage')
      end
    end

    context "when players both have 3 points and player1 scores once" do
      it "does not count as a win" do
        game = Tennis::Game.new
        game.wins_ball(1)#1
        game.wins_ball(2)#1
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)#3
        game.wins_ball(2)#3
        game.wins_ball(1)#4
        # p1: 4  p2: 3

        expect(game.player1.win).to eq(false)
        expect(game.player1.games_won).to eq(0)
      end
    end

    context "when player1 has advantage and scores again" do
      it "returns player1 is the winner" do
        game = Tennis::Game.new
        game.wins_ball(1)#1
        game.wins_ball(2)#1
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)#3
        game.wins_ball(2)#3
        game.wins_ball(1)#4
        game.wins_ball(1)#5
        # p1: 5  p2: 3

        expect(game.player2.win).to eq(false)
        expect(game.player1.win).to eq(true)
      end
    end
  end

  describe  "#games_won" do
    context "when player1 wins a game" do
      it "returns player1.games_won = 1" do
                game = Tennis::Game.new
        game.wins_ball(1)#1
        game.wins_ball(2)#1
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)#3
        game.wins_ball(2)#3
        game.wins_ball(1)#4
        game.wins_ball(1)#5

        expect(game.player1.games_won).to eq(1)
      end
    end

    context "when player1 wins 2 games " do
      it "returns player1.games_won = 2" do
        game = Tennis::Game.new
        game.wins_ball(1)#1
        game.wins_ball(2)#1
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)#3
        game.wins_ball(2)#3
        game.wins_ball(1)#4
        game.wins_ball(1)#5

        expect(game.player1.games_won).to eq(1)

        game.wins_ball(1)#1
        game.wins_ball(2)#1
        game.wins_ball(1)
        game.wins_ball(2)
        game.wins_ball(1)#3
        game.wins_ball(2)#3
        game.wins_ball(1)#4
        game.wins_ball(1)#5

        expect(game.player1.games_won).to eq(2)
      end
    end

    context "when player1 wins 2 games and player2 wins 1" do
      it "returns player1.games_won = 2 and player2.games_won = 1" do
        game = Tennis::Game.new
        3.times {game.wins_ball(2)}
        5.times {game.wins_ball(1)}

        expect(game.player1.games_won).to eq(1)

        3.times {game.wins_ball(2)}
        5.times {game.wins_ball(1)}

        expect(game.player1.games_won).to eq(2)

        3.times {game.wins_ball(1)}
        5.times {game.wins_ball(2)}

        expect(game.player1.points).to eq(0)
        expect(game.player2.points).to eq(0)
        expect(game.player2.win).to eq(true)
        expect(game.player2.games_won).to eq(1)
      end
    end
  end

  describe  '#won_set' do
    context "player1 wins 6 games and player2 wins 0" do
      it "sets player1.sets_won to 1" do
        game = Tennis::Game.new
        4.times {game.wins_ball(1)}#1
        4.times {game.wins_ball(1)}#2
        4.times {game.wins_ball(1)}#3
        4.times {game.wins_ball(1)}#4
        4.times {game.wins_ball(1)}#5
        4.times {game.wins_ball(1)}#6

        expect(game.player1.sets_won).to eq(1)
      end
    end

    context "player2 wins 6 games and player1 wins 5" do
      it "does not increment player1.sets_won" do
        game = Tennis::Game.new
        4.times {game.wins_ball(2)}#1
        4.times {game.wins_ball(2)}#2
        4.times {game.wins_ball(2)}#3
        4.times {game.wins_ball(2)}#4
        4.times {game.wins_ball(2)}#5

        4.times {game.wins_ball(1)}#1
        4.times {game.wins_ball(1)}#2
        4.times {game.wins_ball(1)}#3
        4.times {game.wins_ball(1)}#4
        4.times {game.wins_ball(1)}#5

        4.times {game.wins_ball(2)}#6

        expect(game.player2.sets_won).to eq(0)
      end
    end

    context "player2 wins 7 games and player1 wins 5" do
      it "sets player1.sets_won to 1" do
        game = Tennis::Game.new
        4.times {game.wins_ball(2)}#1
        4.times {game.wins_ball(2)}#2
        4.times {game.wins_ball(2)}#3
        4.times {game.wins_ball(2)}#4
        4.times {game.wins_ball(2)}#5

        4.times {game.wins_ball(1)}#1
        4.times {game.wins_ball(1)}#2
        4.times {game.wins_ball(1)}#3
        4.times {game.wins_ball(1)}#4
        4.times {game.wins_ball(1)}#5

        4.times {game.wins_ball(2)}#6
        4.times {game.wins_ball(2)}#7

        expect(game.player1.sets_won).to eq(0)
        expect(game.player2.sets_won).to eq(1)
      end
    end

    context "player2 wins 7 games and player1 wins 6" do
      it "sets player1.sets_won to 1" do
        game = Tennis::Game.new
        4.times {game.wins_ball(2)}#1
        4.times {game.wins_ball(2)}#2
        4.times {game.wins_ball(2)}#3
        4.times {game.wins_ball(2)}#4
        4.times {game.wins_ball(2)}#5

        4.times {game.wins_ball(1)}#1
        4.times {game.wins_ball(1)}#2
        4.times {game.wins_ball(1)}#3
        4.times {game.wins_ball(1)}#4
        4.times {game.wins_ball(1)}#5
        4.times {game.wins_ball(1)}#6

        4.times {game.wins_ball(2)}#6
        4.times {game.wins_ball(2)}#7

        expect(game.player2.sets_won).to eq(1)
      end
    end
  end

  describe '#won_match' do
    context "player1 wins 2 sets and player2 wins 0" do
      it "sets player1.matches_won to 1" do
        game = Tennis::Game.new
        4.times {game.wins_ball(2)}#1
        4.times {game.wins_ball(2)}#2
        4.times {game.wins_ball(2)}#3
        4.times {game.wins_ball(2)}#4
        4.times {game.wins_ball(2)}#5
        4.times {game.wins_ball(2)}#6

        expect(game.player2.sets_won).to eq(1)

        4.times {game.wins_ball(2)}#1
        4.times {game.wins_ball(2)}#2
        4.times {game.wins_ball(2)}#3
        4.times {game.wins_ball(2)}#4
        4.times {game.wins_ball(2)}#5
        4.times {game.wins_ball(2)}#6

        expect(game.player2.sets_won).to eq(2)
        expect(game.player2.matches_won).to eq(1)
      end
    end
  end
end