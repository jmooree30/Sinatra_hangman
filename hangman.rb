require 'sinatra'
require 'sinatra/reloader' if development?
enable :sessions



helpers do

  def get_word
    array = []
    File.foreach('5text.txt') do |x|
      chomped = x.chomp
      array << chomped if (chomped.length >= 5 and chomped.length <= 12)
    end
    the_word = array.sample 
    return the_word
  end

  def ciphered_word
    session[:get_word].gsub(/[a-z]/, '*').split(//)
  end

  def split_word 
    session[:get_word].split(//)
  end 

  def choice(letter)
    split_word.each_with_index do |i,index|
      if i == letter
        ciphered_word[index] = letter 
      end 
    end   
   # ciphered_word
  end

  def start_game
    session[:counter] = 5
    session[:get_word] = get_word
    session[:ciphered_word] = ciphered_word
    session[:split_word] = split_word
  end 

end

get '/'do
  start_game
  @split_word = session[:split_word]
  @counter = session[:counter]
  @random = session[:get_word]
  @ciphered_word = session[:ciphered_word]
  redirect 'play'
end 

get '/play' do
  @split_word = session[:split_word]
  @counter = session[:counter]
  @random = session[:get_word]
  @ciphered_word = session[:ciphered_word]
  choice(params["text"])
  erb :index
end

