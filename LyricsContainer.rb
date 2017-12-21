class LyricsContainer
  def initialize(lyrics)
    @lyrics = lyrics.split("\n")
    @line = 0
    #puts @lyrics
  end

  def hasNext()
    # Stop early to avoid "not for commercial use" message
    @lyrics.length > @line + 4
  end

  def next()
    @line = @line + 1
    @lyrics[@line]
  end
end
