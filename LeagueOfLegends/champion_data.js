var champList = {
	'Aatrox': ['muscular', 'horns', 'red', 'large', 'black', 'villain', 'swords', 'blood', 'ancient', 'male', 'humanoid', 'serious', 'bloodlust', 'selfish'],
	'Ahri' : ['slender', 'curvy', 'fur', 'pointed ears', 'tails', 'mythology', 'humanoid', 'red', 'white', 'blue', 'female', 'young', 'curious', 'animal-like', 'facial markings', 'magic'],
	'Akali' : ['slender', 'curvy', 'green', 'black', 'humanoid', 'redemption', 'young', 'ninja', 'serious', 'female', 'tatoos', 'katanas'],
	'Akshan' : ['muscular', 'almond', 'gold', 'white', 'humanoid', 'redemption', 'vengeance', 'young', 'selfish', 'facetious', 'male', 'guns'],
	'Alistar' : ['muscular', 'horns', 'fur', 'purple', 'large', 'humanoid', 'mammalian', 'mythology', 'redemption', 'male', 'strength'],
	'Amumu' : ['child', 'green', 'blue', 'small', 'humanoid', 'ancient', 'undead', 'sad', 'male', 'magic'],
	'Anivia' : ['wings', 'blue', 'avian', 'mythology', 'ancient', 'wise', 'female', 'magic', 'ice'],
	'Annie' : ['child', 'pointed ears', 'red', 'small', 'humanoid', 'villain', 'young', 'selfish', 'facetious', 'female', 'magic', 'fire', 'pets'],
	'Aphelios' : ['slender', 'blue', 'large', 'humanoid', 'hero', 'myhtology', 'young', 'celestial', 'serious', 'male', 'facial markings', 'magic', 'guns'],
	'Ashe' : ['slender', 'curvy', 'blue', 'white', 'humanoid', 'hero', 'mythology', 'young', 'leader', 'wise', 'religious', 'female', 'magic', 'ice', 'bows'],
	'AurelionSol' : ['fur', 'horns', 'blue', 'purple', 'draconic', 'celestial', 'selfish', 'bloodlust', 'male', 'magic'],
	'Azir' : ['slender', 'gold', 'large', 'humanoid', 'avian', 'mythology', 'ancient', 'redemption', 'animal-like', 'leader', 'serious', 'mythology', 'male', 'magic', 'armor', 'staves', 'armor'],
	'Bard' : ['fat', 'red', 'gold', 'white', 'large', 'humanoid', 'hero', 'mythology', 'ancient', 'celestial', 'wise', 'magic', 'music'],
	'Blitzcrank' : ['gold', 'large', 'humanoid', 'hero', 'robot', 'curious', 'facetious', 'electricity', 'technology'],
	'Brand' : ['muscular', 'orange', 'humanoid', 'mythology', 'selfish', 'bloodlust', 'vengeance', 'male', 'magic', 'fire'],
	'Braum' : ['muscular', 'pink', 'blue', 'large', 'humanoid', 'hero', 'facetious', 'male', 'tatoos', 'magic', 'strength'],
	'Caitlyn' : ['slender', 'purple', 'gold', 'humanoid', 'hero', 'young', 'serious', 'female', 'guns', 'technology'],
	'Camille' : ['slender', 'gray', 'blue', 'large', 'humanoid', 'old', 'cyborg', 'leader', 'serious', 'technology', 'blades'],
	'Cassiopeia' : ['slender', 'curvy', 'scales', 'green', 'gold', 'almond', 'humanoid', 'reptilian', 'villain', 'mythology', 'young', 'selfish', 'facetious', 'female', 'magic', 'poisons'],
	'Chogath' : ['scales', 'purple', 'large', 'monster', 'villain', 'bloodlust', 'magic'],
	'Corki' : ['fur', 'silver', 'yellow', 'small', 'humanoid', 'mythology', 'facetious', 'male', 'technology', 'mounts', 'explosions'],
	'Darius' : ['muscular', 'red', 'gray', 'large', 'humanoid', 'leader', 'serious', 'bloodlust', 'male', 'strength', 'axes', 'armor'],
	'Diana' : ['slender', 'white', 'silver', 'humanoid', 'vengeance', 'celestial', 'serious', 'religious', 'female', 'facial markings', 'magic', 'scythes'],
	'Draven' : ['muscular', 'brown', 'large', 'humanoid', 'young', 'selfish', 'facetious', 'bloodlust', 'tatoos', 'facial markings', 'strength', 'axes'],
	'DrMundo' : ['muscular', 'purple', 'large', 'humanoid', 'crazy', 'male', 'chemicals'],
	'Ekko' : ['blue', 'brown', 'black', 'humanoid', 'hero', 'young', 'curious', 'wise', 'male', 'facial markings', 'clubs', 'technology'],
	'Elise' : ['slender', 'curvy', 'black', 'red', 'large', 'humanoid', 'arachnid', 'villain', 'young', 'bloodlust', 'selfish', 'female', 'magic', 'pets'],
	'Evelynn' : ['slender', 'curvy', 'tails', 'purple', 'magenta', 'humanoid', 'young', 'facetious', 'bloodlust', 'selfish', 'female', 'magic'],
	'Ezreal' : ['blue', 'gold', 'humanoid', 'demonic', 'young', 'facetious', 'selfish', 'curious', 'male', 'magic'],
	'FiddleSticks' : ['black', 'red', 'humanoid', 'demonic', 'mythology', 'villain', 'bloodlust', 'selfish', 'magic', 'pets'],
	'Fiora' : ['slender', 'white', 'gold', 'magenta', 'humanoid', 'young', 'redemption', 'serious', 'female', 'swords'],
	'Fizz' : ['tails', 'blue', 'white', 'small', 'humanoid', 'piscine', 'young', 'aquatic', 'curious', 'magic', 'trident', 'water'],
	'Galio' : ['muscular', 'tails', 'wings', 'white', 'gold', 'large', 'humanoid', 'lapidarius', 'hero', 'male', 'magic', 'strength', 'wind'],
	'Gangplank' : ['muscular', 'green', 'gold', 'humanoid', 'old', 'vengeance', 'leader', 'pirate', 'serious', 'bloodlust', 'male', 'tatoos', 'swords', 'explosions'],
	'Garen' : ['muscular', 'silver', 'gold', 'blue', 'large', 'humanoid', 'hero', 'young', 'leader', 'serious', 'swords', 'strength', 'armor'],
	'Gnar' : ['muscular', 'child', 'fur', 'tusks', 'pointed ears', 'tails', 'orange', 'white', 'small', 'humanoid', 'mammalian', 'ancient', 'young', 'curious', 'facetious', 'facial markings', 'patterns', 'strength'],
	'Gragas' : ['fat', 'purple', 'orange', 'large', 'humanoid', 'facetious', 'male', 'tatoos', 'facial markings', 'clubs'],
	'Graves' : ['muscular', 'red', 'orange', 'brown', 'humanoid', 'pirate', 'facetious', 'male', 'guns', 'explosions'],
	'Gwen' : ['slender', 'blue', 'white', 'humanoid', 'hero', 'young', 'curious', 'female', 'magic', 'shadows'],
	'Hecarim' : ['blue', 'white', 'humanoid', 'quadrupod', 'villain', 'animal-like', 'undead', 'bloodlust', 'selfish', 'male', 'magic', 'strength', 'armor'],
	'Heimerdinger' : ['fur', 'pointed ears', 'yellow', 'blue', 'silver', 'small', 'humanoid', 'curious', 'male', 'technology', 'pets'],
	'Illaoi' : ['muscular', 'tenticles', 'green', 'brown', 'large', 'humanoid', 'mythology', 'wise', 'religious', 'female', 'tatoos', 'facial markings', 'strength', 'magic', 'clubs'],
	'Irelia' : ['slender', 'pink', 'silver', 'large', 'humanoid', 'hero', 'young', 'serious', 'religious', 'female', 'blades'],
	'Ivern' : ['slender', 'horns', 'green', 'brown', 'yellow', 'large', 'humanoid', 'arboreal', 'old', 'redemption', 'facetious', 'wise', 'crazy', 'male', 'magic', 'pets', 'plants'],
	'Janna' : ['slender', 'white', 'blue', 'humanoid', 'hero', 'mythology', 'female', 'magic', 'staves', 'wind'],
	'JarvanIV' : ['muscular', 'gold', 'brown', 'humanoid', 'young', 'vengeance', 'leader', 'serious', 'male', 'strength', 'lances'],
	'Jax' : ['muscular', 'purple', 'humanoid', 'old', 'male', 'strength', 'clubs'],
	'Jayce' : ['muscular', 'gold', 'blue', 'large', 'humanoid', 'leader', 'male', 'technology', 'electricity', 'hammers', 'guns'],
	'Jhin' : ['white', 'purple', 'gold', 'large', 'humanoid', 'villain', 'crazy', 'bloodlust', 'male', 'technology', 'guns', 'explosions'],
	'Jinx' : ['slender', 'blue', 'silver', 'purple', 'humanoid', 'young', 'crazy', 'bloodlust', 'female', 'tatoos', 'technology', 'explosions', 'guns'],
	'Kaisa' : ['slender', 'curvy', 'scales', 'wings', 'purple', 'gray', 'humanoid', 'young', 'female', 'facial markings', 'magic', 'guns'],
	'Kalista' : ['slender','blue', 'brown', 'humanoid', 'vengeance', 'undead', 'serious', 'bloodlust', 'female', 'spears', 'magic'],
	'Karma' : ['slender', 'wings', 'green', 'purple', 'brown', 'humanoid', 'female', 'magic'],
	'Karthus' : ['slender', 'gray', 'blue', 'humanoid', 'villain', 'undead', 'religious', 'male', 'magic', 'tomes'],
	'Kassadin' : ['muscular', 'horns', 'purple', 'silver', 'humanoid', 'old', 'serious', 'male', 'magic', 'blades', 'armor'],
	'Katarina' : ['slender', 'curvy', 'red', 'silver', 'humanoid', 'bloodlust', 'female', 'blades'],
	'Kayle' : ['slender', 'curvy', 'wings', 'feathers', 'gold', 'orange', 'white', 'humanoid', 'young', 'ancient', 'vengeance', 'celestial', 'serious', 'bloodlust', 'female', 'swords', 'magic', 'fire', 'armor'],
	'Kayn' : ['muscular', 'scales', 'black', 'blue', 'black', 'humanoid', 'demonic', 'young', 'ninja', 'facetious', 'curious', 'bloodlust', 'male', 'magic', 'strength', 'scythes', 'shadows'],
	'Kennen' : ['fur', 'pointed ears', 'purple', 'blue', 'small', 'humanoid', 'ninja', 'serious', 'magic', 'electricity', 'shurikens'],
	'Khazix' : ['scales', 'wings', 'purple', 'large', 'humanoid', 'insectoid', 'bloodlust', 'selfish', 'male', 'strength', 'blades'],
	'Kindred' : ['slender', 'fur', 'horns', 'pointed ears', 'white', 'black', 'purple', 'humanoid', 'mammalian', 'mythology', 'ancient', 'curious', 'wise', 'serious', 'male', 'female', 'magic', 'bows', 'pets'],
	'Kled' : ['fur', 'pointed ears', 'scales', 'tails', 'horns', 'white', 'red', 'silver', 'orange', 'small', 'humanoid', 'reptilian', 'crazy', 'old', 'male', 'strength', 'blades', 'guns', 'mounts'],
	'KogMaw' : ['scales', 'tails', 'gray', 'green', 'small', 'insectoid', 'monster', 'villain', 'bloodlust', 'magic', 'guns'],
	'Leblanc' : ['slender', 'curvy', 'gold', 'purple', 'humanoid', 'villain', 'young', 'ancient', 'leader', 'serious', 'selfish', 'female', 'magic', 'staves'],
	'LeeSin' : ['muscular', 'red', 'blue', 'humanoid', 'serious', 'wise', 'male', 'tatoos', 'strength'],
	'Leona' : ['curvy', 'gold', 'red', 'orange', 'humanoid', 'mythology', 'young', 'celestial', 'leader', 'religious', 'female', 'swords', 'shields', 'magic', 'armor'],
	'Lillia' : ['slender', 'pointed ears', 'fur', 'tails', 'purple', 'blue', 'humanoid', 'quadrupod', 'young', 'animal-like', 'curious', 'female', 'magic', 'plants', 'staves', 'poisons'],
	'Lissandra' : ['slender', 'blue', 'black', 'humanoid', 'mythology', 'young', 'ancient', 'redemption', 'serious', 'sad', 'female', 'magic', 'ice', 'armor'],
	'Lucian' : ['muscular', 'black', 'blue', 'brown', 'humanoid', 'hero', 'young', 'vengeance', 'serious', 'bloodlust', 'male', 'magic', 'guns'],
	'Lulu' : ['child', 'pointed ears', 'wings', 'purple', 'small', 'humanoid', 'young', 'ancient', 'crazy', 'facetious', 'curious', 'female', 'magic', 'pets', 'staves'],
	'Lux' : ['slender', 'yellow', 'white', 'silver', 'humanoid', 'young', 'facetious', 'female', 'magic', 'staves', 'armor'],
	'Malphite' : ['muscular', 'brown', 'large', 'humanoid', 'lapidarius', 'ancient', 'serious', 'male', 'strength', 'magic', 'earth'],
	'Malzahar' : ['purple', 'humanoid', 'villain', 'ancient', 'serious', 'male', 'magic', 'pets'],
	'Maokai' : ['brown', 'blue', 'large', 'humanoid', 'arboreal', 'ancient', 'old', 'sad', 'serious', 'magic', 'strength', 'pets', 'plants'],
	'MasterYi' : ['green', 'gold', 'silver', 'humanoid', 'old', 'serious', 'wise', 'male', 'swords'],
	'MissFortune' : ['slender', 'curvy', 'red', 'pink', 'humanoid', 'vengeance', 'pirate', 'facetious', 'bloodlust', 'female', 'guns'],
	'Mordekaiser' : ['gray', 'green', 'blue', 'large', 'humanoid', 'villain', 'mythology', 'ancient', 'vengeance', 'undead', 'leader', 'serious', 'bloodlust', 'male', 'magic', 'maces', 'armour'],
	'Morgana' : ['slender', 'wings', 'pointed ears', 'purple', 'black', 'humanoid', 'ancieint', 'young', 'celestial', 'redemption', 'vengeance', 'serious', 'female', 'magic'],
	'Nami' : ['slender', 'curvy', 'scales', 'tails', 'green', 'blue', 'humanoid', 'piscine', 'aquatic', 'hero', 'young', 'leader', 'animal-like', 'curious', 'female', 'magic', 'water', 'staves'],
	'Nasus' : ['muscular', 'fur', 'pointed ears', 'gold', 'purple', 'blue', 'brown', 'humanoid', 'mammalian', 'hero', 'redemption', 'leader', 'serious', 'religious', 'mythology', 'ancient', 'wise', 'male', 'axes', 'magic'],
	'Nautilus' : ['brown', 'blue', 'large', 'humanoid', 'mythology', 'aquatic', 'water', 'strength'],
	'Neeko' : ['slender', 'pointed ears', 'scales', 'tails', 'green', 'gold', 'blue', 'humanoid', 'reptilian', 'ancient', 'young', 'curious', 'female', 'patterns', 'magic'],
	'Nidalee' : ['slender', 'fur', 'tusks', 'pointed ears', 'tails', 'green', 'brown', 'humanoid', 'quadrupod', 'mammalian', 'animal-like', 'young', 'female', 'tatoos', 'facial markings', 'patterns', 'magic', 'strength', 'spears'],
	'Nocturne' : ['black', 'red', 'humanoid', 'monster', 'villain', 'ancient', 'bloodlust', 'serious', 'male', 'magic', 'shadows'],
	'Nunu' : ['fat', 'child', 'fur', 'horns', 'pointed ears', 'tusks', 'white', 'blue', 'large', 'small', 'humanoid', 'mammalian', 'young', 'male', 'magic', 'ice'],
	'Olaf' : ['muscular', 'red', 'gray', 'large', 'humanoid', 'mythology', 'bloodlust', 'male', 'strength', 'axes'],
	'Orianna' : ['slender', 'white', 'brown', 'blue', 'humanoid', 'robot', 'serious', 'female', 'technology', 'pets', 'electricity'],
	'Ornn' : ['muscular', 'horns', 'fur', 'tails', 'red', 'black', 'large', 'humanoid', 'mammalian', 'old', 'ancient', 'mythology', 'leader', 'serious', 'wise', 'male', 'magic', 'strength', 'hammers'],
	'Pantheon' : ['muscular', 'gold', 'large', 'humanoid', 'young', 'vengeance', 'celestial', 'serious', 'bloodlust', 'male', 'tatoos', 'facial markings', 'spears', 'strength', 'shields'],
	'Poppy' : ['pointed ears', 'fur', 'gold', 'yellow', 'white', 'small', 'humanoid', 'hero', 'female', 'magic', 'hammers', 'armor'],
	'Pyke' : ['muscular', 'green', 'blue', 'black', 'humanoid', 'vengeance', 'aquatic', 'pirate', 'serious', 'bloodlust', 'male', 'blades'],
	'Qiyana' : ['slender', 'curvy', 'green', 'gold', 'leader', 'facetious', 'selfish', 'female', 'blades', 'magic'],
	'Quinn' : ['slender', 'curvy', 'feathers', 'tails', 'wings', 'blue', 'gold', 'humanoid', 'avian', 'young', 'facetious', 'animal-like', 'female', 'pets', 'bows', 'mounts'],
	'Rakan' : ['muscular', 'slender', 'wings', 'pointed ears', 'feathers', 'tails', 'red', 'gold', 'humanoid', 'avian', 'young', 'vengeance', 'animal-like', 'facetious', 'selfish', 'male', 'magic'],
	'Rammus' : ['horns', 'scales', 'yellow', 'green', 'small', 'humanoid', 'reptilian', 'ancient', 'facetious', 'strength'],
	'RekSai' : ['scales', 'tusks', 'tails', 'purple', 'blue', 'large', 'monster', 'villain', 'ancient', 'bloodlust', 'magic', 'strength'],
	'Rell' : ['curvy', 'tails', 'gray', 'gold', 'humanoid', 'quadrupod', 'young', 'vengeance', 'serious', 'bloodlust', 'female', 'lances', 'pets', 'armor', 'magic'],
	'Renekton' : ['muscular', 'tails', 'green', 'silver', 'large', 'humanoid', 'reptilian', 'villain', 'ancient', 'vengeance', 'animal-like', 'serious', 'mythology', 'bloodlust', 'selfish', 'crazy', 'religious', 'male', 'blades', 'strength'],
	'Rengar' : ['muscular', 'fur', 'pointed ears', 'tails', 'gray', 'large', 'humanoid', 'mammalian', 'serious', 'bloodlust', 'male', 'blades', 'strength'],
	'Riven' : ['slender', 'green', 'humanoid', 'young', 'redemption', 'serious', 'sad', 'female', 'swords', 'magic', 'strength'],
	'Rumble' : ['fur', 'red', 'gray', 'blue', 'small', 'humanoid', 'facetious', 'male', 'technology', 'electricity', 'fire', 'mounts'],
	'Ryze' : ['muscular', 'blue', 'purple', 'humanoid', 'old', 'serious', 'wise', 'male', 'tatoos', 'facial markings', 'magic', 'tomes', 'runes'],
	'Samira' : ['curvy', 'red', 'black', 'almond', 'humanoid', 'bloodlust', 'serious', 'female', 'tatoos', 'swords', 'guns'],
	'Sejuani' : ['slender', 'curvy', 'horns', 'fur', 'pointed ears', 'tails', 'tusks', 'blue', 'gray', 'humanoid', 'mammalian', 'young', 'mythology', 'leader', 'serious', 'bloodlust', 'clubs', 'pets', 'magic', 'strength'],
	'Senna' : ['slender', 'curvy', 'black', 'white', 'gray', 'humanoid', 'hero', 'young', 'wise', 'female', 'magic', 'guns', 'shadows'],
	'Seraphine' : ['slender', 'pink', 'humanoid', 'young', 'leader', 'female', 'facial markings', 'magic', 'technology'],
	'Sett' : ['muscular', 'fur', 'pointed ears', 'gold', 'blue', 'large', 'humanoid', 'mammalian', 'animal-like', 'young', 'serious', 'male', 'strength'],
	'Shaco' : ['slender', 'red', 'black', 'humanoid', 'villain', 'facetious', 'bloodlust', 'crazy', 'male', 'magic', 'blades'],
	'Shen' : ['muscular', 'blue', 'purple', 'humanoid', 'hero', 'old', 'ninja', 'vengeance', 'leader', 'serious', 'religious', 'male', 'swords', 'strength', 'magic', 'armor'],
	'Shyvana' : ['slender', 'curvy', 'horns', 'scales', 'wings', 'tails', 'red', 'gold', 'large', 'humanoid', 'draconic', 'young', 'mythology', 'serious', 'female', 'magic', 'strength', 'fire'],
	'Singed' : ['slender', 'green', 'humanoid', 'old', 'serious', 'wise', 'chemicals', 'poisons'],
	'Sion' : ['muscular', 'tusks', 'red', 'black', 'large', 'humanoid', 'old', 'vengeance', 'undead', 'serious', 'bloodlust', 'axes', 'strength', 'magic'],
	'Sivir' : ['slender', 'curvy', 'gold', 'humanoid', 'young', 'mythology', 'serious', 'female', 'blades', 'magic'],
	'Skarner' : ['scales', 'horns', 'purple', 'blue', 'arachnid', 'ancient', 'vengeance', 'sad', 'serious', 'bloodlust', 'magic', 'strength', 'earth'],
	'Sona' : ['slender', 'curvy', 'blue', 'gold', 'purple', 'green', 'humanoid', 'young', 'facetious', 'female', 'magic', 'music'],
	'Soraka' : ['slender', 'curvy', 'horns', 'tails', 'purple', 'orange', 'humanoid', 'mammalian', 'ancient', 'celestial', 'curious', 'wise', 'female', 'tatoos', 'magic', 'staves'],
	'Swain' : ['muscular', 'feathers', 'tails', 'red', 'black', 'humanoid', 'demonic', 'old', 'vengeance', 'serious', 'bloodlust', 'male', 'magic', 'pets', 'electricity', 'armor'],
	'Sylas' : ['muscular', 'gold', 'blue', 'humanoid', 'young', 'vengeance', 'leader', 'serious', 'facetious', 'bloodlust', 'male', 'tatoos', 'magic', 'runes', 'earth'],
	'Syndra' : ['slender', 'curvy', 'black', 'purple', 'humanoid', 'ancient', 'young', 'vengenace', 'celestial', 'serious', 'sad', 'bloodlust', 'female', 'magic'],
	'TahmKench' : ['fat', 'green', 'brown', 'large', 'humanoid', 'piscine', 'mythology', 'ancient', 'aquatic', 'facetious', 'wise', 'bloodlust', 'male', 'magic', 'strength'],
	'Taliyah' : ['slender', 'red', 'brown', 'humanoid', 'hero', 'young', 'redemption', 'leader', 'curious', 'religious', 'female', 'magic', 'earth'],
	'Talon' : ['blue', 'silver', 'humanoid', 'young', 'male', 'blades'],
	'Taric' : ['muscular', 'blue', 'purple', 'humanoid', 'young', 'mythology', 'celestial', 'leader', 'serious', 'wise', 'religious', 'male', 'strength', 'magic', 'earth',],
	'Teemo' : ['fur', 'pointed ears', 'brown', 'purple', 'green', 'small', 'humanoid', 'mythology', 'leader', 'facetious', 'male', 'magic', 'poisons'],
	'Thresh' : ['green', 'blue', 'humanoid', 'undead', 'villain', 'ancient', 'facetious', 'bloodlust', 'male', 'magic', 'scythes'],
	'Tristana' : ['slender', 'pointed ears', 'purple', 'gray', 'small', 'humanoid', 'leader', 'serious', 'female', 'guns', 'explosions'],
	'Trundle' : ['muscular', 'fur', 'pointed ears', 'blue', 'white', 'large', 'humanoid', 'mythology', 'leader', 'facetious', 'bloodlust', 'male', 'clubs', 'strength', 'magic'],
	'Tryndamere' : ['muscular', 'silver', 'red', 'humanoid', 'young', 'vengeance', 'serious', 'bloodlust', 'male', 'swords', 'strength'],
	'TwistedFate' : ['brown', 'yellow', 'red', 'gold', 'blue', 'humanoid', 'pirate', 'facetious', 'magic'],
	'Twitch' : ['fur', 'pointed ears', 'tails', 'gray', 'green', 'humanoid', 'mammalian', 'facetious', 'bloodlust', 'crazy', 'male', 'poisons', 'bows'],
	'Udyr' : ['muscular', 'fur', 'wings', 'brown', 'orange', 'green', 'humanoid', 'mythology', 'animal-like', 'religious', 'strength', 'magic', 'fire'],
	'Urgot' : ['muscular', 'gray', 'green', 'large', 'humanoid', 'cyborg', 'villain', 'serious', 'bloodlust', 'tatoos', 'technology', 'guns', 'strength', 'chemicals'],
	'Varus' : ['muscular', 'pointed ears', 'black', 'purple', 'humanoid', 'ancient', 'vengeance', 'undead', 'serious', 'bloodlust', 'male', 'facial markings', 'magic', 'bows'],
	'Vayne' : ['slender', 'curvy', 'silver', 'red', 'humanoid', 'young', 'vengeance', 'serious', 'bloodlust', 'sad', 'female', 'bows'],
	'Veigar' : ['purple', 'black', 'blue', 'small', 'humanoid', 'ancient', 'facetious', 'male', 'magic', 'staves'],
	'Velkoz' : ['tenticles', 'purple', 'large', 'monster', 'ancient', 'serious', 'wise', 'bloodlust', 'magic'],
	'Vex' : ['fur', 'pointed ears', 'black', 'purple', 'small', 'humanoid', 'sad', 'female', 'magic', 'shadows'],
	'Vi' : ['curvy', 'pink', 'blue', 'gray', 'humanoid', 'hero', 'facetious', 'female', 'facial markings', 'technology', 'strength', 'armor'],
	'Viego' : ['slender', 'muscular', 'white', 'green', 'humanoid', 'villain', 'young', 'ancient', 'redemption', 'leader', 'undead', 'serious', 'male', 'swords', 'magic', 'shadows'],
	'Viktor' : ['gray', 'orange', 'purple', 'humanoid', 'cyborg', 'wise', 'male', 'technology', 'fire', 'armor'],
	'Vladimir' : ['slender', 'red', 'humanoid', 'ancient', 'facetious', 'wise', 'bloodlust', 'selfish', 'male', 'magic', 'blood'],
	'Volibear' : ['muscular', 'fur', 'tails', 'white', 'blue', 'large', 'humanoid', 'mammalian', 'ancient', 'mythology', 'leader', 'serious', 'bloodlust', 'selfish', 'male', 'magic', 'strength', 'electricity'],
	'Warwick' : ['muscular', 'fur', 'pointed ears', 'tails', 'green', 'red', 'large', 'humanoid', 'mammalian', 'animal-like', 'bloodlust', 'crazy', 'male', 'strength', 'chemicals'],
	'WuKong' : ['muscular', 'fur', 'red', 'gold', 'humanoid', 'mammalian', 'mythology', 'facetious', 'male', 'facial markings', 'strength', 'magic', 'staves', 'armor'],
	'Xayah' : ['slender', 'feathers', 'pointed ears', 'tails', 'wings', 'purple', 'red', 'humanoid', 'avian', 'young', 'animal-like', 'leader', 'serious', 'female', 'facial markings', 'blades'],
	'Xerath' : ['blue', 'humanoid', 'villain', 'mythology', 'ancient', 'vengeance', 'serious', 'bloodlust', 'male', 'magic'],
	'XinZhao' : ['muscular', 'white', 'gold', 'blue', 'humanoid', 'young', 'hero', 'serious', 'male', 'strength', 'lances', 'armor'],
	'Yasuo' : ['muscular', 'blue', 'white', 'humanoid', 'redemption', 'serious', 'sad', 'male', 'katanas', 'wind', 'strength'],
	'Yone' : ['muscular', 'red', 'white', 'humanoid', 'demonic', 'young', 'redemption', 'undead', 'serious', 'bloodlust', 'male', 'katanas', 'magic', 'strength', 'wind'],
	'Yorick' : ['muscular', 'blue', 'gray', 'humanoid', 'old', 'serious', 'ancient', 'sad', 'male', 'magic', 'club', 'pets'],
	'Yuumi' : ['fur', 'blue', 'yellow', 'small', 'mammalian', 'curious', 'female', 'magic', 'tomes', 'pets', 'mounts'],
	'Zac' : ['muscular', 'green', 'large', 'humanoid', 'monster', 'young', 'male', 'strength', 'chemicals'],
	'Zed' : ['muscular', 'silver', 'red', 'black', 'humanoid', 'ninja', 'leader', 'serious', 'wise', 'male', 'blades', 'shadows', 'magic', 'strength'],
	'Zeri' : ['curvy', 'green', 'yellow', 'humanoid', 'hero', 'young', 'facetious', 'female', 'facial markings', 'guns', 'electricity', 'magic', 'technology'],
	'Ziggs' : ['fur', 'pointed ears', 'tails', 'red', 'brown', 'small', 'humanoid', 'crazy', 'facetious', 'male', 'explosions', 'technology'],
	'Zilean' : ['blue', 'gold', 'humanoid', 'old', 'ancient', 'serious', 'wise', 'male', 'magic', 'technology'],
	'Zoe' : ['child', 'gold', 'purple', 'orange', 'small', 'humanoid', 'mythology', 'young', 'ancient', 'facetious', 'crazy', 'religious', 'female', 'magic'],
	'Zyra' : ['slender', 'curvy', 'pointed ears', 'purple', 'red', 'green', 'humanoid', 'young', 'ancient', 'curious', 'selfish', 'female', 'magic', 'plants']
};