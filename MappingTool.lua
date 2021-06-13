
MappingTool = Object:extend()

-- for the actual song gameplay, we'd probably iterate over the table of tables & check
-- if Source:tell() >= noteTime (the time at which the note should fall)
-- and then

-- input: name of song, BPM of song, length of songBPM
-- function: constructor for new mapped songs
function MappingTool:new(songName, songBPM, songLength)
  self.songName = songName
  self.songBPM = songBPM
  self.songLength = songLength
  self.noteTable = {}
end

-- input: position (from 0 to 1), beat number (in song, ZERO INDEXED)
-- function: adds note to the noteTable array for a song object.
function MappingTool:mapNote(position, beatNum)
  notePos = position*windowWidth
  noteTime = beatNum*60/self.songBPM
  noteData = {notePos, noteTime}
  table.insert(self.noteTable, noteData)
end
