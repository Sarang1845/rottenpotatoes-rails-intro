class Movie < ActiveRecord::Base
    
    @@possible_ratings = ['G','PG','PG-13','R']
    def self.allratings
        return @@possible_ratings
    end
end
