const URL = 'https://api.guildwars2.com/';

const DAILY_CRAFTING_ITEMS = {
	'glob_of_elder_spirit_residue': 46744,
	'lump_of_mithrilium': 46742,
	'spool_of_silk_weaving_thread': 46740,
	'spool_of_thick_elonian_cord': 46745
}
const VENDOR_PRICES = {
	46747: 149.6, //thermocatalytic reagent
	19750: 16, //lump of coal
	19924: 48, //lump of primordium
	19790: 64 //spool of gossamer thread
	
}

var settings = {
	'doDeepCrafting': true,
	'inspectBank': true,
	'inspectInventory': true,
	'includeNotLearnedRecipes': true
}

document.addEventListener('DOMContentLoaded', e => {
	document.getElementById('apikey').value = getAPIKey();
	
	//Configure based on local storage settings
	for (setting of Object.keys(settings)) {
		let savedSetting = ( localStorage.getItem(`setting|${setting}`) === 'true' ); //convert string to bool
		if (savedSetting != null) {
			settings[setting] = savedSetting;
			document.getElementById(setting).checked = savedSetting;
		}
	}
});


async function dailyCrafting() {
	toggleLoader('block');
	const APIKEY = getAPIKey();
	getSettings();
	
	let finalRecipes = [];
	let needsCrafting = await getNeededDailyCrafting(APIKEY);
	
	if (needsCrafting.length == 0) { errMsg('You cannot craft any time-gated recipes yet!'); return; }
	
	for (let itemID of needsCrafting) {
		let useRecipes = await getUsedInRecipes(itemID);
		let profitRecipe = await findMostProfitableRecipe(APIKEY, useRecipes);
		finalRecipes.push(profitRecipe);
	}
	
	addCraftingCards(finalRecipes);
}


function getSettings() {
	
	for (setting of Object.keys(settings)) {
		let currentSetting = document.getElementById(setting).checked;
		settings[setting] = currentSetting;
		localStorage.setItem(`setting|${setting}`, currentSetting);
	}
}


async function addMakingCard(itemID) {
	toggleLoader('block');
	const APIKEY = getAPIKey();
	getSettings();
	
	let makeRecipes = await getMakingRecipes(itemID);
	if (makeRecipes == null) { errMsg('Item does not have a crafting recipe!'); return; }
	let cheapestRecipe = await findCheapestRecipe(APIKEY, 1, makeRecipes);
	
	if (cheapestRecipe == null) { errMsg('No recipe with these settings exists!'); return; }
	
	addCraftingCards(cheapestRecipe);
}


async function addUsingCard(itemID) {
	toggleLoader('block');
	const APIKEY = getAPIKey();
	getSettings();
	
	let useRecipes = await getUsedInRecipes(itemID);
	if (useRecipes == null) { errMsg('No recipe uses this item!'); return; }
	let profitRecipe = await findMostProfitableRecipe(APIKEY, useRecipes);

	if (Object.keys(profitRecipe.crafted).length == 0 &&
		Object.keys(profitRecipe.bought).length == 0 &&
		Object.keys(profitRecipe.bound).length == 0) 
		{ errMsg('No recipe with these settings exists!'); return; }
	
	addCraftingCards(profitRecipe);
}


async function findMostProfitableRecipe(apikey, ...recipes) {
	let recipesCollapsed = Array.isArray(recipes[0]) ? recipes[0] : recipes;
	
	let profitRecipe = null;
	for (let recipe of recipesCollapsed) {
		
		let cheapRecipe = await findCheapestRecipe(apikey, 1, recipe);
		
		if (cheapRecipe == null) { continue; }
		
		let outputID = cheapRecipe.output_item_id;
		let outputCount = cheapRecipe.output_item_count;
		let outputSellPrice = (await getTPPrice(outputID))[outputID].sellPrice;
		let tempProfit = outputSellPrice / outputCount * .85 - cheapRecipe.cost;
		//console.log('Output Stuff', outputID, outputSellPrice, cheapRecipe.cost);
		
		if (profitRecipe == null || tempProfit > profitRecipe.profit) {
			cheapRecipe.profit = Math.round(tempProfit);
			profitRecipe = cheapRecipe;
		}
	}
	
	return profitRecipe;
}


function getAPIKey() {
	let apiKey = document.getElementById('apikey').value;
	
	//Check localStorage
	let storedApiKey = localStorage.getItem('apikey');
	if (storedApiKey) {
		if (apiKey == storedApiKey || apiKey == '') {
				return storedApiKey;
		}
	}
	
	if (apiKey == '') {
		console.log('API Key is required');
		return null;
	}
	
	localStorage.setItem('apikey', apiKey);
	return apiKey;
}


function clearCraftingCards() {
	document.getElementById('craftingCardsContainer').innerHTML = '';
}


function softRefresh() {
	sessionStorage.clear();
}


function hardRefresh() {
	softRefresh();
	localStorage.clear();
}


function toggleLoader(forceState) {
	let modal = document.getElementById('modal');
	
	
	if (forceState) { modal.style.display = forceState; return; }
	
	if (modal.style.display == 'block') { modal.style.display = 'none'; }
	else if (modal.style.display == 'none') { modal.style.display = 'block'; }
}


//TODO: implement a modal and create error in console
function errMsg(msg) {
	alert(msg);
	toggleLoader('none');
}


async function findCheapestRecipe(apikey, recipeAmount, ...recipes) {
	let recipesCollapsed = Array.isArray(recipes[0]) ? recipes[0] : recipes;
	
	let cheapestRecipe = null;
	
	for (let recipe of recipesCollapsed) { //Iterate through recipes
		
		if (!settings.includeNotLearnedRecipes) { //Remove recipes you cannot craft
			if ( !( await canCraftRecipe(apikey, recipe) ) ) { continue; }
		}
		
		let outputCount = recipe.output_item_count;
		let totalCost = 0;
		let totalBoughtIngredients = {};
		let totalCraftedIngredients = {};
		let totalBoundIngredients = {};
		let haveIngredientCounts = {};
		
		for (let ingredient of recipe.ingredients) { //iterate through ingredients
			
			let ingredientID = ingredient.item_id;
			let ingredientCount = ingredient.count * recipeAmount;
			
			//Subtract ingredients if user already has it
			if ( (settings.inspectBank || settings.inspectInventory) && haveIngredientCounts[ingredientID] == null) {
				haveIngredientCounts[ingredientID] = await countInventories(apikey, ingredientID);
			}
			if (haveIngredientCounts[ingredientID] > 0) {
				let difference = clamp(haveIngredientCounts[ingredientID], 0, ingredientCount);
				ingredientCount -= difference;
				haveIngredientCounts[ingredientID] -= difference;
				//console.log('Ingredient Substract', ingredientID);
				
				if (ingredientCount == 0) { /*console.log('Enough', ingredientID);*/ continue; }
			}
			
			let ingredientTPPrice = await getTPPrice(ingredientID);
			let ingredientBuyPrice = ingredientTPPrice[ingredientID].buyPrice;
			let ingredientVendorPrice = VENDOR_PRICES[ingredientID];
			
			if (settings.doDeepCrafting) { //get ingredients for ingredients
				let ingredientMakingRecipes = await getMakingRecipes(ingredientID);
				if (ingredientMakingRecipes == null) { //when ingredient doesn't have crafting recipe 
					
					if (ingredientVendorPrice) { //when vendor sells item. Vendor usually cheapest
						totalCost += Math.min(ingredientVendorPrice, ingredientBuyPrice) * ingredientCount;
						//console.log('Vendor', ingredientID, VENDOR_PRICES[ingredientID], ingredientCount);
					} else { //when uncraftable and no vendor
						totalCost += ingredientBuyPrice * ingredientCount;
						//console.log('TP1', ingredientID, ingredientBuyPrice, ingredientCount);
					}
					
					if (ingredientBuyPrice != 0) { //if not unsellable
						totalBoughtIngredients[ingredientID] = totalBoughtIngredients[ingredientID] ? totalBoughtIngredients[ingredientID] + ingredientCount : ingredientCount;
					} else {
						totalBoundIngredients[ingredientID] = totalBoundIngredients[ingredientID] ? totalBoundIngredients[ingredientID] + ingredientCount : ingredientCount;
					}
				
				} else { //when craftable
					let cheapestIngredientRecipe = await findCheapestRecipe(apikey, ingredientCount, ingredientMakingRecipes);
					
					if (cheapestIngredientRecipe == null) { continue; }
					
					if (cheapestIngredientRecipe.cost < (ingredientBuyPrice * ingredientCount) || ingredientBuyPrice == 0) {
						totalCost += cheapestIngredientRecipe.cost;
						//console.log('Crafting', ingredientID, cheapestIngredientRecipe.cost, ingredientCount, cheapestIngredientRecipe);
						
						totalBoughtIngredients = addObjs(totalBoughtIngredients, cheapestIngredientRecipe.bought);
						totalBoundIngredients = addObjs(totalBoundIngredients, cheapestIngredientRecipe.bound);
						totalCraftedIngredients = addObjs(totalCraftedIngredients, cheapestIngredientRecipe.crafted);
						totalCraftedIngredients[ingredientID] = totalCraftedIngredients[ingredientID] ? totalCraftedIngredients[ingredientID] + ingredientCount : ingredientCount;
						
					} else {
						//console.log('TP2 price b4', totalCost);
						totalCost += ingredientBuyPrice * ingredientCount;
						
						if (ingredientBuyPrice != 0) { //if not unsellable
							totalBoughtIngredients[ingredientID] = totalBoughtIngredients[ingredientID] ? totalBoughtIngredients[ingredientID] + ingredientCount : ingredientCount;
						} else {
							totalBoundIngredients[ingredientID] = totalBoundIngredients[ingredientID] ? totalBoundIngredients[ingredientID] + ingredientCount : ingredientCount;
						}
						
						//console.log('TP2', ingredientID, ingredientBuyPrice, ingredientCount);
					}
				
				}
			} else { //doDeepCrafting is false
				
				if (ingredientVendorPrice) {
					totalCost += Math.ceil(ingredientVendorPrice * ingredientCount);
					//console.log('Not Deep1', ingredientID, ingredientVendorPrice , ingredientCount);
				} else {
					totalCost += ingredientBuyPrice * ingredientCount;
					//console.log('Not Deep2', ingredientID, ingredientBuyPrice, ingredientCount);
				}
				
				if (ingredientBuyPrice != 0) {
					totalBoughtIngredients[ingredientID] = totalBoughtIngredients[ingredientID] ? totalBoughtIngredients[ingredientID] + ingredientCount : ingredientCount;
				} else {
					totalBoundIngredients[ingredientID] = totalBoundIngredients[ingredientID] ? totalBoundIngredients[ingredientID] + ingredientCount : ingredientCount;
				}
				
			}
		}
		
		recipe.cost = totalCost / outputCount; //price per unit
		recipe.bought = totalBoughtIngredients;
		recipe.crafted = totalCraftedIngredients;
		recipe.bound = totalBoundIngredients;
		if (cheapestRecipe == null || cheapestRecipe.cost > recipe.cost) {
			cheapestRecipe = recipe;
		}
	}
	
	return cheapestRecipe;
}


//Return array of recipes which use itemID
async function getUsedInRecipes(itemID) {
	let usedInRecipeIDs = await getData('v2', 'recipes/search', `input=${itemID}`);
	
	if (usedInRecipeIDs.length == 0) { return null; }
	
	return await getData('v2', 'recipes', `ids=${usedInRecipeIDs.join()}`);
}


//Return array of recipes which result in itemID
async function getMakingRecipes(itemID) {
	let makingRecipeIDs = await getData('v2', 'recipes/search', `output=${itemID}`);
	
	if (makingRecipeIDs.length == 0) { return null; }
	
	return await getData('v2', 'recipes', `ids=${makingRecipeIDs.join()}`);
}


async function getTPPrice(...itemIDs) {
	let itemIDsCollapsed = Array.isArray(itemIDs[0]) ? itemIDs[0] : itemIDs;
	let listingObjs = {};
	
	//Check session storage
	for (let i in itemIDsCollapsed) {
		let itemID = itemIDsCollapsed[i];
		let storedPrices = sessionStorage.getItem('itemPrices|' + itemID);
		if (storedPrices) {
			itemIDsCollapsed.splice(i, 1);
			listingObjs[itemID] = JSON.parse(storedPrices);
		}
	}
	
	if (itemIDsCollapsed.length == 0) {return listingObjs}
	
	let TPListings = await getData('v2', 'commerce/listings', `ids=${itemIDsCollapsed}`);
	
	if (!Array.isArray(TPListings)) { //When unsellable
		itemIDsCollapsed.forEach(itemID => {
			listingObjs[itemID] = {}
			listingObjs[itemID].sellPrice = 0;
			listingObjs[itemID].buyPrice = 0;
			sessionStorage.setItem('itemPrices|' + itemID, JSON.stringify(listingObjs[itemID]));
		});
	} else {
		for (let listingObj of TPListings) {
			let itemID = listingObj.id;
			listingObjs[itemID] = {};
			
			let sellPrice, buyPrice = 0;
			let buyOrders = listingObj.buys;
			if (buyOrders.length != 0) { sellPrice = buyOrders[0].unit_price; }
			let sellOrders = listingObj.sells;
			if (sellOrders.length != 0) { buyPrice = sellOrders[0].unit_price; }
			
			listingObjs[itemID].sellPrice = sellPrice;
			listingObjs[itemID].buyPrice = buyPrice;
			sessionStorage.setItem('itemPrices|' + itemID, JSON.stringify(listingObjs[itemID]));
		}
	}
	
	return listingObjs;
}


//Time-gated crafting that has not yet been crafted today
//Return array of timed-gated crafting item IDs
async function getNeededDailyCrafting(apikey) {
	let hasCrafted = await getDailyCrafted(apikey);
	let needCrafting = [];
	
	Object.keys(DAILY_CRAFTING_ITEMS).forEach(item => {
		if (!hasCrafted.includes(item)) {
			needCrafting.push(DAILY_CRAFTING_ITEMS[item]);
		}
	});
	
	return needCrafting;
}


//Time-gated recipes that the user already crafted today
async function getDailyCrafted(apikey) {
	return await getData('v2', 'account/dailycrafting', `access_token=${apikey}`);
}


async function canCraftRecipe(apikey, recipe) {
	let trainedDisciplines = await getCraftingDisciplines(apikey);
	
	for (disciplineName of recipe.disciplines) {
		if (trainedDisciplines[disciplineName] && trainedDisciplines[disciplineName] >= recipe.min_rating) {
			if (recipe.flags.includes('AutoLearned')) { return true; }
			else {
				let unlockedRecipes = await getUnlockedRecipes(apikey);
				if (unlockedRecipes.includes(recipe.id)) { return true; }
			} 
		}
	}
	
	return false;
}


async function getUnlockedRecipes(apikey) {
	
	//Check session storage
	let storedUnlockedRecipes = localStorage.getItem('unlockedRecipes');
	if (storedUnlockedRecipes) { return JSON.parse(storedUnlockedRecipes); }
	
	let unlockedRecipes = await getData('v2', 'account/recipes', `access_token=${apikey}`);
	localStorage.setItem('unlockedRecipes', JSON.stringify(unlockedRecipes));
	
	return unlockedRecipes;
}


async function getCraftingDisciplines(apikey) {
	//Check local storage
	let storedDisciplines = localStorage.getItem('craftingDisciplines');
	if (storedDisciplines) { return JSON.parse(storedDisciplines); }
	
	let accountDisciplines = {};
	let charNames = await getCharacterNames(apikey);
	for (name of charNames) {
		
		let charDisciplines = (await getCharacterCraftingDisciplines(apikey, name)).crafting;
		for (discipline of charDisciplines) {
			
			if (discipline.active == false) { continue; }
			
			let disciplineName = discipline.discipline;
			if (accountDisciplines[disciplineName] == null) {
				accountDisciplines[disciplineName] = discipline.rating;
			} else {
				if (accountDisciplines[disciplineName] < discipline.rating) {
					accountDisciplines[disciplineName] = discipline.rating;
				}
			}
		}
	}
	
	localStorage.setItem('craftingDisciplines', JSON.stringify(accountDisciplines));
	return accountDisciplines;
}


async function getCharacterCraftingDisciplines(apikey, charName) {
	let name = encodeURIComponent(charName);
	return await getData('v2', `characters/${name}/crafting`, `access_token=${apikey}`);
}


async function countInventories(apikey, itemID) {
	let count = 0;
	
	if (settings.inspectInventory) {
		let sharedInv = await getSharedInventory(apikey);
		for (itemObj of sharedInv) {
			if (itemObj != null && itemObj.id == itemID) { count += itemObj.count; }
		}
		
		let charNames = await getCharacterNames(apikey);
		for (name of charNames) {
			let inv = await getInventory(apikey, name);
			for (bagObj of inv.bags) {
				for (itemObj of bagObj.inventory) {
					if (itemObj != null && itemObj.id == itemID) { count += itemObj.count; }
				}
			}
		}
	}
	
	if (settings.inspectBank) {
		let bank = await getBank(apikey);
		for (itemObj of bank) {
			if (itemObj != null && itemObj.id == itemID) { count += itemObj.count; }
		}
		
		let matsBank = await getMaterialStorage(apikey);
		for (itemObj of matsBank) {
			if (itemObj.id == itemID) { count += itemObj.count; }
		}
	}
	
	return count;
}


async function getSharedInventory(apikey) {
	
	//Check session storage
	let storedSharedInv = sessionStorage.getItem('sharedInv');
	if (storedSharedInv) { return JSON.parse(storedSharedInv); }
	
	let sharedInv = await getData('v2', 'account/inventory', `access_token=${apikey}`);
	sessionStorage.setItem('sharedInv', JSON.stringify(sharedInv));
	
	return sharedInv;
}


async function getInventory(apikey, charName) {
	
	//Check session storage
	let storedInv = sessionStorage.getItem('inv');
	if (storedInv) { return JSON.parse(storedInv); }
	
	let name = encodeURIComponent(charName);
	let inv = await getData('v2', `characters/${name}/inventory`, `access_token=${apikey}`);
	sessionStorage.setItem('inv', JSON.stringify(inv));
	
	return inv;
}

async function getCharacterNames(apikey) {
	
	//Check local storage
	let storedCharNames = localStorage.getItem('charNames');
	if (storedCharNames) { return JSON.parse(storedCharNames); }
	
	let charNames = await getData('v2', 'characters', `access_token=${apikey}`);
	localStorage.setItem('charNames', JSON.stringify(charNames));
	
	return charNames;
}


async function getBank(apikey) {
	
	//Check session storage
	let storedBank = sessionStorage.getItem('bank');
	if (storedBank) { return JSON.parse(storedBank); }
	
	let bank = await getData('v2', 'account/bank', `access_token=${apikey}`);
	sessionStorage.setItem('bank', JSON.stringify(bank));
	
	return bank;
}


async function getMaterialStorage(apikey) {
	
	//Check session storage
	let storedMatsBank = sessionStorage.getItem('matsBank');
	if (storedMatsBank) { return JSON.parse(storedMatsBank); }
	
	let matsBank = await getData('v2', 'account/materials', `access_token=${apikey}`);
	sessionStorage.setItem('matsBank', JSON.stringify(matsBank));
	
	return matsBank;
}


async function getItem(...itemIDs) {
	let itemIDsCollapsed = Array.isArray(itemIDs[0]) ? itemIDs[0] : itemIDs;
	let itemObjs = [];
	
	//Check session storage
	for (let i in itemIDsCollapsed) {
		let itemID = itemIDsCollapsed[i];
		let storedItem = sessionStorage.getItem('item|' + itemID);
		if (storedItem) {
			itemIDsCollapsed.splice(i, 1);
			itemObjs.push(JSON.parse(storedItem));
		}
	}
	
	if (itemIDsCollapsed.length == 0) { return itemObjs }
	
	let itemData = await getData('v2', 'items', `ids=${itemIDsCollapsed}`)
	for (let itemObj of itemData) {
		itemObjs.push(itemObj);
		sessionStorage.setItem('item|' + itemObj.id, JSON.stringify(itemObj));
	}
	
	return itemObjs;
}


async function getMapIcon(...mapIconIDs) {
	let mapIconIDsCollapsed = Array.isArray(mapIconIDs[0]) ? mapIconIDs[0] : mapIconIDs;
	let mapIconObjs = [];
	
	//Check session storage
	for (let i in mapIconIDsCollapsed) {
		let mapIconID = mapIconIDsCollapsed[i];
		let storedMapIcon = sessionStorage.getItem('mapIcon|' + mapIconID);
		if (storedMapIcon) {
			mapIconIDsCollapsed.splice(i, 1);
			mapIconObjs.push(JSON.parse(storedMapIcon));
		}
	}
	
	if (mapIconIDsCollapsed.length == 0) { return mapIconObjs; }
	
	let mapIconData = await getData('v2', 'files', `ids=${mapIconIDsCollapsed}`);
	for (let mapIconObj of mapIconData) {
		mapIconObjs.push(mapIconObj);
		sessionStorage.setItem('mapIcon|' + mapIconObj.id, JSON.stringify(mapIconObj));
	}
	
	return mapIconObjs;
}


async function getData(version, endpoint, param = '') {
	const response = await fetch(`${URL}${version}/${endpoint}?${param}`);
	return response.json();
}


function moneyToCoins(num) {
	let result = {};
	
	let copper = parseInt(('' + num).slice(-2));
	if (isNaN(copper)) { copper = 0; }
	
	let silver = parseInt(('' + num).slice(-4, -2));
	if (isNaN(silver)) { silver = 0; }
	
	let gold = parseInt(('' + num).slice(0, -4));
	if (isNaN(gold)) { gold = 0; }
	
	return {'gold': gold, 'silver': silver, 'copper': copper};
}


function addObjs(obj1, obj2) {
	let result = obj1;
	for (let obj2Key of Object.keys(obj2)) {
		let property1 = obj1[obj2Key];
		let property2 = obj2[obj2Key];
		result[obj2Key] = property1 ? property1 + property2 : property2;
	}
	
	return result;
}


function clamp(num, min, max) {
	return Math.min(Math.max(min, num), max);
}