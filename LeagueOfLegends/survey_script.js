//Settings
let numCycles = 9;
let tilesPerCycle = 8;


//--------------------------------------
//DO NOT EDIT PAST THIS LINE
//--------------------------------------

//https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Zeri_0.jpg

let mainContainer;
let shuffledChamps = shuffleArray(Object.keys(champList));
let likedTraits = {};
let likedChamps = [];
let cycles = 0;
let traitCount = {};

window.addEventListener("load", function() {
	countTraits();
	mainContainer = document.getElementById("main");
	cycleSet(shuffledChamps, tilesPerCycle);
	/*
	.forEach((name, i) => {
		mainContainer.appendChild(createLoadImg(name));
	});
	*/
	
});

function createLoadImg(champName) {
	return new html('img')
		.attr('src', 'assets/loading/' + champName + '_0.jpg')
		.attr('onclick', 'clicked(this);')
		.attr('name', champName)
		.css({
			'opacity' : 0.6,
			'width' : '231px',
			'height' : '420px',
			'object-fit' : 'scale-down'
			//'margin' : '20px 20px 0px 0px'
		})
		.allDone();
}

function cycleSet(names, amount) {
	removeAllChildNodes(mainContainer);
	for (let i=0;i<amount;i++) {
		let name = names[0];
		if (name) {
			mainContainer.appendChild( createLoadImg( names[0] ) );
			shuffledChamps.shift();
		}
	}
}

function toggleOpacity(element) {
	var currentOpacity = element.style["opacity"];
	if (currentOpacity == 1) { element.style["opacity"] = 0.6; }
	else { element.style["opacity"] = 1; }
}

function clicked(element) {
	toggleOpacity(element);
}

function shuffleArray(array) { //Fisher-Yates algorithm
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    const temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
  
  return array;
}

function removeAllChildNodes(parent) {
	while (parent.firstChild) {
		parent.removeChild(parent.firstChild);
	}
}

function nextSet() {
	if (cycles == numCycles) { end() }
	
	mainContainer.childNodes.forEach((child, i) => {
		if (child.style["opacity"] == 1) {
		let name = child.name;
		
		champList[name].forEach((trait, i) => {
			if (likedTraits[trait]) {
				likedTraits[trait] = likedTraits[trait] + 1;
			} else {
				likedTraits[trait] = 1;
			}
		});
		
		likedChamps.push(name);
	}
	});
	
	cycleSet(shuffledChamps, tilesPerCycle);
	cycles = cycles + 1;
}

function sortObjectValues(obj) {
	return Object.entries(obj).sort(([,a], [,b]) => b-a);
}

function processTraits(amount) {
	let sortedTraits = sortObjectValues(likedTraits);
	let topTraits = [];
	
	for(let i=0;i<amount;i++) {
		let trait = sortedTraits[i][0]
		if (trait) {
			topTraits.push(trait);
		}
	}
	
	return topTraits;
}

function similarChamp() {
	let champ;
	let score = 0;
	
	Object.keys(champList).forEach((name, i) => {
		let tempScore = 0;
		let champTraits = champList[name];
		
		champTraits.forEach((trait, j) => {
			if (likedTraits.hasOwnProperty(trait)) {
				let traitValue = likedTraits[trait];
				tempScore = tempScore + ( traitValue / champTraits.length );
			}
		});
		
		if (tempScore > score) {
			score = tempScore;
			champ = name;
		}
	});
	
	return champ;
}

function end() {
	let div = mainContainer.parentElement;
	removeAllChildNodes(div);
	
	let perfectChamp = similarChamp();
	
	let newContainer = new html('div')
		.tag('label')
			.text('Traits that appeal to you:')
			.attr('for', 'traits')
			.done()
		.tag('textarea')
			.text( processTraits(10).join(', ') )
			.attr('readonly')
			.attr('id', 'traits')
			.css('width', '100%')
			.css('height', '80px')
			.done()
		.newLine()
		.tag('label')
			.text('Champs chosen:')
			.attr('for', 'champs')
			.done()
		.tag('textarea')
			.text( likedChamps.join(', ') )
			.attr('readonly')
			.attr('id', 'champs')
			.css('width', '100%')
			.css('height', '80px')
			.done()
		.newLine()
		.tag('center')
			.tag('h3')
				.text("Your 'perfect' champion is: " + perfectChamp)
				.done()
			.tag('img')
				.attr('src', 'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/' + perfectChamp + '_0.jpg')
				.css('width', '100%')
				.done()
			.done()
		.allDone();
	
	div.appendChild(newContainer);
}