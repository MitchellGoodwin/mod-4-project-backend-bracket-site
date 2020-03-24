class Bracket < ApplicationRecord
    belongs_to :user

    has_many :entries, before_add: :validate_entry_limit
    has_many :entrants, through: :entries, :source => :user
    has_many :matches

    def resolve_winner(match, winner)
      match.winner = winner
      match.save
      if match.round != self.num_rounds
        new_round = match.round + 1
        new_set = (match.set + 1) / 2
        new_match = Match.find_by(round: new_round, set: new_set, bracket: self)
        if match.set.even?
          new_match.user_two = winner
        else
          new_match.user_one = winner
        end 
        new_match.save
      else
        match.bracket.status = 'finished'
        match.bracket.save
      end
    end


    def num_rounds
      self.matches.map{|match| match.round}.uniq.sort.last
    end

    def resolve_byes
      self.matches.select{|match| match.round == 1}.each do |match|
        if !match.user_one || !match.user_two
          if match.user_one
            match.bracket.resolve_winner(match, match.user_one)
          else
            match.bracket.resolve_winner(match, match.user_two)
          end
        end
      end
      self.matches.reload()
    end

    def sort_entrants_by_seed(competitors) # It's easier to seed the bracket by seperating into subbrackets of 4 competitors
      if competitors.length < 4
        return competitors
      end
      num_sections = competitors.length / 4
      i = 1
      subbrackets = {}
      newcomp = competitors
      while i <= num_sections
        subbrackets[i] = [newcomp.shift(), newcomp.pop(), newcomp.delete_at(newcomp.length / 2 - 1), newcomp.delete_at(newcomp.length / 2)]
        i += 1
      end
      if num_sections == 1
        subbrackets = subbrackets[1]
      elsif num_sections == 2 
        subbrackets = subbrackets[1] + subbrackets[2]
      elsif num_sections == 4
        subbrackets = subbrackets[1] + subbrackets[4] + subbrackets[2] + subbrackets[3]
      elsif num_sections == 8
        subbrackets = subbrackets[1] + subbrackets[8] + subbrackets[4] + subbrackets[5] + subbrackets[2] + subbrackets[7] + subbrackets[3] + subbrackets[6]
      elsif num_sections == 16 
        subbrackets = subbrackets[1] + subbrackets[16]  + subbrackets[8] + subbrackets[9]  + subbrackets[4] + subbrackets[13] + subbrackets[5] + subbrackets[12] + subbrackets[2] + subbrackets[15] + subbrackets[7] + subbrackets[10] + subbrackets[3] + subbrackets[14] + subbrackets[6] + subbrackets[11]
      elsif num_sections == 32
        subbrackets = subbrackets[1] + subbrackets[32] + subbrackets[16] + subbrackets[17]  + subbrackets[8] + subbrackets[25] + subbrackets[9] + subbrackets[24]  + subbrackets[4] + subbrackets[29] + subbrackets[13] + subbrackets[20] + subbrackets[5] + subbrackets[28] + subbrackets[12] + subbrackets[21] + subbrackets[2] + subbrackets[31] + subbrackets[15] + subbrackets[18] + subbrackets[7] + subbrackets[26] + subbrackets[10] + subbrackets[23] + subbrackets[3] + subbrackets[30] + subbrackets[14] + subbrackets[19] + subbrackets[6] + subbrackets[27] + subbrackets[11] + subbrackets[22]
      end
      # this is a mess, be smarter
      return subbrackets
    end

    def create_matches
      self.matches.destroy_all
      competitors = self.entries.sort_by{|entrant| entrant.seed}.map{|entry| entry.user}
      bracket_size = 2
      while competitors.length > bracket_size do
        bracket_size *= 2
      end
      puts "Bracket size: #{bracket_size}"
      while competitors.length < bracket_size do
        competitors.push(nil)
      end
      competitors = self.sort_entrants_by_seed(competitors)
      i = 0
      x = 1
      while i <= bracket_size - 2
        Match.create(bracket: self, user_one: competitors[i], user_two: competitors[i + 1], round: 1, set: x)
        i += 2
        x += 1
      end
      round = 2
      bracket_size /= 2
      while bracket_size > 1
        i = 1
        while i <= bracket_size / 2
          Match.create(bracket: self, user_one: nil, user_two: nil, round: round, set: i)
          i += 1
        end
        round += 1
        bracket_size /= 2
      end
      self.reload()
      self.resolve_byes
    end

    private

    def validate_entry_limit(entry)
      raise Exception.new if entries.size >= 128
    end
end
