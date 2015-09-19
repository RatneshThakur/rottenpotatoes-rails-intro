class Movie < ActiveRecord::Base
	def Movie.getRatings
		ratingsArray = []
		Movie.all.each {|movie| ratingsArray.push(movie.rating)}
		ratingsArray.uniq
	end
end
