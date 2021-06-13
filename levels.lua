Levels = Object:extend()

function Levels:new()
    require "enemy"
    self.level = 0
    self.count = 0
    self.score = 0
    self.enemy_list = {}
    self.timings = {
        {4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16.5, 17, 17.5, 18, 18.75, 19.5, 19.75, 20.5, 21, 21.5, 22, 22.5, 22.75, 23.25, 23.5, 23.75, 24, 24.5, 25, 25.5, 26, 26.75, 27, 27.25, 27.5, 27.57, 28.5, 29, 29.5, 30, 30.5, 30.75, 31, 31.25, 31.5, 31.75, 32, 32.5, 33, 33.5, 34, 34.5, 34.75, 34.75, 35, 35.25, 35.25, 35.5, 35.75, 36, 36.5, 37, 37.5, 38, 38.5, 39, 39, 39.25, 39.25, 39.5, 39.5, 39.75, 39.75, 40, 40, 40.5, 40.5, 41, 41, 41.5, 41.5, 42, 42, 42.5, 42.5, 42.75, 42.75, 43, 43, 43.25, 43.25, 43.5, 43.5, 43.75, 43.75, 44, 45, 46, 46.5, 47, 48, 48, 48, 48, 49, 49, 49, 49, 50, 50, 50, 50, 51.5, 51.5, 51.5, 51.5, 51.5, 52, 52, 52, 52, 52, 53.5, 53.5, 53.5, 53.5, 53.5, 54, 54, 54, 54, 54, 54.5, 54.5, 54.5, 54.5, 54.5, 55, 55, 55, 55, 55, 56, 56, 57, 57, 58, 58, 59, 59, 60, 61, 62, 63, 64, 64.5, 65, 65.5, 66, 66.5, 67, 67.5, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 178.5, 179.5, 182.5, 183.5, 186.5, 187.5, 190.5, 191.5, 194.5, 195.5, 198.5, 199.5, 202.5, 203.5, 10000},
        {4, 6, 7, 8, 10, 12, 13, 15, 18, 19, 20, 22, 23, 24, 26, 28, 29, 31, 34, 35, 36, 38, 39, 40, 42, 44, 45, 47, 50, 51, 52, 54, 55, 56, 58, 60, 62, 64.5, 64.75, 65, 65.25, 65.5, 65.75, 66, 66.5, 67, 67.5, 68, 69, 69.75, 71, 72, 73, 73.75, 75, 76, 77, 77.75, 79, 80, 81, 81.75, 83, 84, 85, 85.75, 87, 88, 89, 89.75, 91, 92, 93, 93.75, 95, 96, 97, 97.75, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 133.75, 135, 136, 137, 137.75, 139, 140, 141, 141.75, 143, 144, 145, 145.75, 147, 148, 149, 149.75, 151, 152, 153, 153.75, 155, 156, 157, 157.75, 159, 160, 161, 161.75, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 204, 206, 208, 208, 208.5, 208.5, 209, 209, 209.5, 209.5, 210, 210, 210.25, 210.25, 210.5, 210.5, 210.75, 210.75, 211, 211, 211.25, 211.25, 211.5, 211.75, 212, 213, 213.75, 215, 216, 217, 217.75, 219, 220, 221, 221.75, 223, 224, 225, 225.75, 227, 228, 229, 229.75, 231, 232, 233, 233.75, 235, 236, 237, 237.75, 239, 240, 241, 241.75, 243, 244, 244.25, 244.25, 244.5, 244.5, 244.75, 244.75, 245, 245, 245.25, 245.25, 245.5, 245.5, 245.75, 245.75, 246, 246, 246.25, 246.25, 246.5, 246.5, 246.75, 246.75, 247, 247, 247.25, 247.25, 247.5, 247.5, 247.75, 247.75, 248, 249, 249.75, 251, 252, 253, 253.75, 255, 256, 257, 257.75, 259, 260, 261, 261.75, 263, 264, 265, 265.75, 267, 268, 269, 269.75, 271, 272, 273, 273.75, 275, 276, 277, 277.75, 279, 280, 10000}
    }
    self.positions = {
        {0.8, 0.2, 0.7, 0.3, 0.8, 0.2, 0.7, 0.3, 0.8, 0.2, 0.7, 0.3, 0.8, 0.2, 0.7, 0.3, 0.8, 0.2, 0.7, 0.3, 0.65, 0.35, 0.55, 0.45, 0.2, 0.25, 0.3, 0.25, 0.3, 0.35, 0.7, 0.8, 0.8, 0.75, 0.7, 0.65, 0.7, 0.75, 0.4, 0.3, 0.2, 0.3, 0.3, 0.3, 0.3, 0.3, 0.6, 0.65, 0.7, 0.75, 0.8, 0.9, 0.9, 0.9, 0.9, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.3, 0.7, 0.25, 0.75, 0.2, 0.8, 0.4, 0.6, 0.5, 0.4, 0.6, 0.5, 0.5, 0.4, 0.4, 0.6, 0.6, 0.7, 0.7, 0.4, 0.6, 0.4, 0.6, 0.4, 0.6, 0.4, 0.6, 0.7, 0.9, 0.7, 0.9, 0.1, 0.3, 0.1, 0.3, 0.3, 0.7, 0.3, 0.7, 0.25, 0.75, 0.2, 0.8, 0.15, 0.85, 0.1, 0.9, 0.05, 0.95, 0.9, 0.2, 0.7, 0.4, 0.5, 0.8, 0.6, 0.4, 0.2, 0.8, 0.6, 0.4, 0.2, 0.8, 0.6, 0.4, 0.2, 0.9, 0.7, 0.5, 0.3, 0.1, 0.9, 0.7, 0.5, 0.3, 0.1, 0.9, 0.7, 0.5, 0.3, 0.1, 0.9, 0.7, 0.5, 0.3, 0.1, 0.9, 0.7, 0.5, 0.3, 0.1, 0.9, 0.7, 0.5, 0.3, 0.1, 0.4, 0.6, 0.4, 0.6, 0.4, 0.6, 0.4, 0.6, 0.311434288, 0.149355509, 0.9324055532, 0.7092565857, 0.131266584, 0.2934168479, 0.5011437535, 0.1522142342, 0.6885758623, 0.9724324827, 0.976217201, 0.6615235027, 0.8322813152, 0.09001574795, 0.2628007755, 0.4321235384, 0.2131210824, 0.3091605932, 0.7867793348, 0.3570219934, 0.4496412583, 0.1009337777, 0.4471105572, 0.7616719937, 0.4302336041, 0.3619318209, 0.3260775148, 0.9145264498, 0.1279606569, 0.6112753755, 0.8666900037, 0.4890933024, 0.1652601432, 0.6148276743, 0.6024702266, 0.1303541353, 0.5072205623, 0.6524880271, 0.6820850685, 0.2871980313, 0.08497262212, 0.5438252227, 0.3697635887, 0.5125609342, 0.8548422455, 0.9779796356, 0.4221650463, 0.5042506233, 0.7842619442, 0.6556774489, 0.7433393281, 0.2619758243, 0.5220404079, 0.24436342, 0.001648209802, 0.8698875923, 0.05843960165, 0.1718741774, 0.9559922483, 0.5789796407, 0.5096123906, 0.8397364125, 0.08341515804, 0.05998365859, 0.2713035777, 0.9240898246, 0.7261333732, 0.9249349102, 0.178319704, 0.05039794682, 0.3832658615, 0.8743717778, 0.9791245324, 0.2775241178, 0.9610150718, 0.1171728112, 0.3890180089, 0.5074143788, 0.7647769567, 0.03132344051, 0.2207088302, 0.1485423327, 0.7676344457, 0.3864433885, 0.6076920145, 0.1044361558, 0.2219151923, 0.8326955607, 0.133694167, 0.4330208164, 0.9939711133, 0.7757355175, 0.7605512672, 0.8281736344, 0.09706372313, 0.203650069, 0.8072346908, 0.4118046371, 0.7732158561, 0.5093726972, 0.8743434205, 0.1929378265, 0.1321170266, 0.8608523583, 0.5312313505, 0.9496830298, 0.793646003, 0.2112910369, 0.787040762, 0.2206523798, 0.2003010251, 0.6130553299, 0.8522638833, 0.5542893829, 0.2668043229, 0.1014054499, 0.4640568167, 0.1577428594, 0.8163746004, 0.04797458585, 0.09638086849, 0.6113315614, 0.8166371591, 0.5489706967, 0.7051487649, 0.3703099568, 0.7728685538, 0.1093615366, 0.2689037573, 0.3625592742, 0.7622484054, 0.6118431469, 0.2771622795, 0.1089923738, 0.5000185776, -1000},
        {0.454810724962795, 0.7752907332, 0.04663448615, 0.2183395167, 0.2463629402, 0.4689482526, 0.844408138, 0.1458960947, 0.823164162, 0.8428295777, 0.352564674, 0.05266964133, 0.5203510777, 0.8146473818, 0.3364907327, 0.1900754187, 0.2868909837, 0.3303295041, 0.5964923282, 0.2583836209, 0.08056176461, 0.9234926389, 0.403243716, 0.8152595058, 0.06497683732, 0.7244908623, 0.04919999199, 0.728192523, 0.7709170211, 0.3471695357, 0.4853647751, 0.09748090196, 0.2875514519, 0.4300887027, 0.1192486273, 0.7531955459, 0.1087001177, 0.8, 0.85, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.8638627951, 0.1125501167, 0.5125551091, 0.4751111542, 0.8973960078, 0.9360360582, 0.8734022113, 0.9257957235, 0.3831758714, 0.5142932758, 0.7149779169, 0.2997844892, 0.3954200291, 0.02446906731, 0.878950156, 0.6142390399, 0.3347542667, 0.3008133907, 0.2116590192, 0.08567277727, 0.4192327371, 0.8407805285, 0.7627999689, 0.05810543888, 0.1538935906, 0.6086440167, 0.3562735429, 0.7552964079, 0.9696769171, 0.1890228716, 0.6756884515, 0.5837714555, 0.7274138112, 0.3554139554, 0.3400121993, 0.1791786203, 0.1937288206, 0.7877689412, 0.1841213847, 0.5105788678, 0.9130807412, 0.4983511481, 0.1045119302, 0.1355974601, 0.1237989435, 0.5065517625, 0.3821869326, 0.1339326037, 0.4958563483, 0.4410409546, 0.3527476921, 0.337537638, 0.5042519226, 0.04157425392, 0.6579714148, 0.2228641851, 0.1942587628, 0.982970157, 0.08366711055, 0.2338732281, 0.9434270837, 0.05022019716, 0.1653581392, 0.364091665, 0.5801133703, 0.4563877779, 0.3263490413, 0.541812668, 0.8794405814, 0.01389779608, 0.3019907654, 0.7346073724, 0.02497649539, 0.9450140447, 0.9994671373, 0.7176371576, 0.09805059674, 0.3487469038, 0.7441826717, 0.1348247714, 0.03651238691, 0.7291288823, 0.07184006278, 0.822763761, 0.7908667479, 0.5337413758, 0.8395531803, 0.3643156533, 0.5981053307, 0.3515707788, 0.4498492953, 0.4921644789, 0.3921849954, 0.2757176063, 0.4081722228, 0.2721689588, 0.3749877409, 0.9491778331, 0.2675057485, 0.9621725608, 0.6827292634, 0.9808606087, 0.2529943987, 0.06400230876, 0.9001656186, 0.7442018654, 0.5049467599, 0.3647072257, 0.8985811538, 0.05217897358, 0.9303640166, 0.6976577566, 0.103422711, 0.8402266916, 0.1111443996, 0.7449480688, 0.8335787474, 0.7824995946, 0.5813720472, 0.4496127439, 0.7966843506, 0.71712242, 0.05660641488, 0.5094905537, 0.1734659469, 0.8625139512, 0.8748464231, 0.9841377344, 0.9790226733, 0.06956636931, 0.9918511902, 0.2620135474, 0.5, 0.5, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.1, 0.9, 0.5, 0.5, 0.7553684431, 0.946578973, 0.793972401, 0.7760030824, 0.01384565104, 0.7594408254, 0.7555900387, 0.9403498254, 0.6837429021, 0.4752497433, 0.5934337132, 0.3563703465, 0.4215994995, 0.5016284118, 0.158619778, 0.1817682065, 0.7694898901, 0.08600107462, 0.6838353012, 0.06748898506, 0.5388748057, 0.2165423836, 0.2496881814, 0.9185769053, 0.9307778455, 0.8299548257, 0.949006912, 0.6902075545, 0.4007404, 0.8543033925, 0.4787342934, 0.7222234826, 0.5, 0.53, 0.47, 0.56, 0.44, 0.59, 0.41, 0.62, 0.38, 0.65, 0.35, 0.68, 0.32, 0.71, 0.29, 0.74, 0.26, 0.77, 0.23, 0.8, 0.2, 0.83, 0.17, 0.86, 0.14, 0.89, 0.11, 0.92, 0.08, 0.95, 0.05, 0.6334542706, 0.5418940827, 0.6986305807, 0.6203815709, 0.5046652385, 0.880190608, 0.1618212572, 0.1036544713, 0.5768874384, 0.6080214847, 0.744295161, 0.5543107575, 0.5006629965, 0.5098377226, 0.2787790509, 0.2311317299, 0.674546636, 0.2125384266, 0.5329849813, 0.2360048933, 0.6546909604, 0.6673906326, 0.9630469031, 0.360268035, 0.09885249103, 0.8638262306, 0.4200338331, 0.8795593917, 0.4798346607, 0.09240758925, 0.3907465655, 0.2145631789, 0.4098287063, -1000}
    }
    self.bpm = {
        120,
        128
    }
    self.hit = function()
        hitsound = love.audio.newSource("hit.mp3", "stream")
        hitsound:setVolume(0.5)
        love.audio.play(hitsound)
    end
    self.perfect = function()
        hitsound = love.audio.newSource("perfect.mp3", "stream")
        hitsound:setVolume(0.3)
        love.audio.play(hitsound)
    end
    self.double = function()
        hitsound = love.audio.newSource("double.mp3", "stream")
        hitsound:setVolume(0.3)
        love.audio.play(hitsound)
    end
end

-- Set the level to 1 before generate
function Levels:generate(t)
    enemy_sizew, enemy_sizeh = 60, 10
    enemy_speed = 500
    offset = 0
    -- change this to true for offsets
    if true then
        offset = (windowHeight-30)/enemy_speed
    end
    if  self.count < #self.timings[self.level] then
        while t + offset >= self.timings[self.level][self.count + 1]*60/self.bpm[self.level] do
            self.count = self.count + 1
            x_pos = windowWidth * self.positions[self.level][self.count] - enemy_sizew/2
            y_pos = 0 -- for now
            curr_enemy = Enemy(x_pos, y_pos, enemy_sizew, enemy_sizeh, enemy_speed, t)
            table.insert(self.enemy_list, curr_enemy)
            if self.count + 1 > #self.timings[self.level] then
                break
            end
        end
    end
end

function Levels:update(dt)
  for i, enemy in pairs(self.enemy_list) do
    -- self.enemy_list[i]:update(dt)
    if self.enemy_list[i].y > windowHeight + 50  then
      table.remove(self.enemy_list, i)
    end

  end

end

function Levels:draw(t)
    for i, enemy in pairs(self.enemy_list) do
      self.enemy_list[i]:draw(t)
    end
end

function Levels:setLevel(lvl)
    self.level = lvl
    self.score = 0
    self.count = 0
end

function Levels:resolveDoubleCollisions(LXLocation, LYLocation, RXLocation, MagnetHeight, MagnetWidth)
  for i, enemy in pairs(self.enemy_list) do
    EXLocation, EYLocation, EnemyHeight, EnemyWidth = self.enemy_list[i]:getEnemyProperties()
    if EXLocation > LXLocation
    and EXLocation < LXLocation + MagnetWidth
    and EXLocation + EnemyWidth > RXLocation
    and EXLocation + EnemyWidth < RXLocation + MagnetWidth
    and EYLocation + EnemyHeight > LYLocation
    and EYLocation < LYLocation + MagnetHeight then
      toggleDouble()
      for j=1,10 do
        self.score = self.score + self.enemy_list[i].point
      end
      self.enemy_list[i].point = 0
      -- include this if you want the block to disappear
      self.enemy_list[i]:begone()
      self.double()
      return true
    end
  end
  if double == true then
    return true
  elseif double == false then
    return false
  end
end

function Levels:resolveLCollisions(LXLocation, LYLocation, MagnetHeight, MagnetWidth)
    for i, enemy in pairs(self.enemy_list) do
      EXLocation, EYLocation, EnemyHeight, EnemyWidth = self.enemy_list[i]:getEnemyProperties()
      if EXLocation + EnemyWidth > LXLocation
      and EXLocation < LXLocation + MagnetWidth
      and EYLocation + EnemyHeight > LYLocation
      and EYLocation < LYLocation + MagnetHeight then
        if EXLocation - LXLocation < 10 and EXLocation - LXLocation > -10 then
          togglePerfect()
          for j=1,5 do
            self.score = self.score + self.enemy_list[i].point
          end
          self.enemy_list[i].point = 0
          -- include this if you want the block to disappear
          self.enemy_list[i]:begone()
          self.perfect()

        else
          toggleGood()
          self.score = self.score + self.enemy_list[i].point
          self.enemy_list[i].point = 0
          -- include this if you want the block to disappear
          self.enemy_list[i]:begone()
          self.hit()
        end
      end
    end
  end

  function Levels:resolveRCollisions(RXLocation, RYLocation, MagnetHeight, MagnetWidth)
      for i, enemy in pairs(self.enemy_list) do
        EXLocation, EYLocation, EnemyHeight, EnemyWidth = self.enemy_list[i]:getEnemyProperties()
        if EXLocation + EnemyWidth > RXLocation
        and EXLocation < RXLocation + MagnetWidth2
        and EYLocation + EnemyHeight > RYLocation
        and EYLocation < RYLocation + MagnetHeight2 then
          if EXLocation - RXLocation < 10 and EXLocation - RXLocation > -10 then
            togglePerfect()
            for j=1,5 do
              self.score = self.score + self.enemy_list[i].point
            end
            self.enemy_list[i].point = 0
            -- include this if you want the block to disappear
            self.enemy_list[i]:begone()
            self.perfect()

          else
            toggleGood()
            self.score = self.score + self.enemy_list[i].point
            self.enemy_list[i].point = 0
            -- include this if you want the block to disappear
            self.enemy_list[i]:begone()
            self.hit()

          end
        end
      end
    end
