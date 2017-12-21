READ ME

———————————
Command Line Arguments
———————————

* Path to the mp3 file

Example:  ruby main.rb 2.mp3

————————————
Design Decisions & Issues
————————————

For project 3, I have designed an application that takes an mp3 file as its argument, identifies the song, gathers lyrics, and shows the next event of the artist. With the help of acoustid fingerprinter that uses Chromaprint, I calculate the fingerprint for the given mp3 file.    (Downloaded from: https://acoustid.org/fingerprinter). After calculating the fingerprint, I call the acoustid API to identify the song. I take the result with the highest result and assume that it has the correct artist and track title. Track information is then passed to the musixmatch API to fetch the lyrics of the song. Since I don’t have a license, it only returns the first 30% of the lyrics. Finally, I call the bandsintown API with the artist information to retrieve the earliest concert (or other events) available for the artist. 

The application is split into a few layers, including the main driver and the application logic, API related classes and utilities for logging, and a lyrics collection to filter the trailing warning messages from the lyrics. I used the proxy pattern to access APIs and encapsulate connection details. To achieve that I used a base proxy class that consist of 2 shared functions initialize and callApi. With initialize I set the base url with placeholders for parameters to access; and with callApi, established the connections and logged connections made and also parsed the response from API. I have three separate proxy classes for each API in these classes I called the functions from their super class and handled exceptions(begin-rescue), also logged the response from API. 

I also used the singleton module provided by Ruby for the Log class. I used JSON module as well to read data from APIs and log data in JSON format. The reason I have used singleton pattern for my log class is that since we are writing on a filesystem having more than one instance of log class can cause garbled files.

The third pattern I have used is the iterator. Normally, response returned by LyricsApi ends with a line indicating that I am using the free version of the API. To avoid that I created the LyricsContainer class which is an iterator that iterates through lyrics.