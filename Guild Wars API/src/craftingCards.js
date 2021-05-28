async function addCraftingCards(...recipes) {
	let recipesCollapsed = Array.isArray(recipes[0]) ? recipes[0] : recipes;
	
	for (let recipe of recipesCollapsed) {
		let outputID = recipe.output_item_id;
		let outputItem = (await getItem(outputID))[0];
		let outputName = outputItem.name;
		let outputIcon = outputItem.icon;
		let outputRarity = outputItem.rarity.toLowerCase();
		
		let profit = recipe.profit;
		let cost = recipe.cost;
		let profitCoins = moneyToCoins(profit);
		let displayProfit = displayCoins('Profit:', profitCoins);
		let costCoins = moneyToCoins(cost);
		let displayCost = displayCoins('Cost:', costCoins)
		
		let card = new html('table')
			.attr('class', 'craftingCard')
			.tag('span')
				.addClass('closeButton')
				.attr('onClick', 'this.parentElement.remove()')
				.text('X')
			.done()
			.tag('tr')
				.tag('td')
					.tag('img')
						.attr('src', outputIcon)
						.addClass(outputRarity)
					.done()
				.done()
				.tag('th')
					.tag('p')
						.addClass(outputRarity)
						.text(outputName)
					.done()
					.pause();
					
		if (profit != null && profit != 0) { card.resume().node(displayProfit).pause(); }			
		if (cost != null && cost != 0) { card.resume().node(displayCost).pause() }
		
		card.resume()
				.done()
			.done()
			.pause();
			
		//Bound
		if (Object.keys(recipe.bound).length != 0) {
			card.resume()
				.tag('tr')
					.tag('td')
						.attr('colspan', 2)
						.tag('hr')
						.done()
					.done()	
				.done()
				.tag('tr')
					.tag('th')
						.text('Accquire these Bound Items')
						.attr('colspan', 2)
					.done()
				.done()
				.pause();
			
			let boundItems = await getItem(Object.keys(recipe.bound)); //Have
			for (boundItem of boundItems) {
				let itemID = boundItem.id;
				let itemName = boundItem.name;
				let itemCount = recipe.bound[itemID];
				let itemIcon = boundItem.icon;
				let itemRarity = boundItem.rarity.toLowerCase();
				
				card.resume()
					.tag('tr')
						.tag('td')
							.tag('img')
								.attr('src', itemIcon)
								.addClass(itemRarity)
								.addClass('ingredient')
							.done()
						.done()
						.tag('td')
							.tag('span')
								.text(`${itemCount}x `)
							.done()
							.addClass(itemRarity)
							.text(itemName)
						.done()
					.done()
					.pause();
			}
		}
		
		//Buy
		if (Object.keys(recipe.bought).length != 0) {
			card.resume()
				.tag('tr')
					.tag('td')
						.attr('colspan', 2)
						.tag('hr')
						.done()
					.done()	
				.done()
				.tag('tr')
					.tag('th')
						.text('Buy These')
						.attr('colspan', 2)
					.done()
				.done()
				.pause();
			
			let buyItems = await getItem(Object.keys(recipe.bought));
			for (buyItem of buyItems) {
				let itemID = buyItem.id;
				let itemName = buyItem.name;
				let itemCount = recipe.bought[itemID];
				let itemIcon = buyItem.icon;
				let itemRarity = buyItem.rarity.toLowerCase();
				
				card.resume()
					.tag('tr')
						.tag('td')
							.tag('img')
								.attr('src', itemIcon)
								.addClass(itemRarity)
								.addClass('ingredient')
							.done()
						.done()
						.tag('td')
							.tag('span')
								.text(`${itemCount}x `)
							.done()
							.addClass(itemRarity)
							.text(itemName)
						.done()
					.done()
					.pause();
			}
		}
		
		//Craft
		if (Object.keys(recipe.crafted).length != 0) {
			card.resume()
				.tag('tr')
					.tag('td')
						.attr('colspan', 2)
						.tag('hr')
						.done()
					.done()	
				.done()
				.tag('tr')
					.tag('th')
						.text('Craft These')
						.attr('colspan', 2)
					.done()
				.done()
				.pause();
			
			let craftItems = await getItem(Object.keys(recipe.crafted));
			for (craftItem of craftItems) {
				let itemID = craftItem.id;
				let itemName = craftItem.name;
				let itemCount = recipe.crafted[itemID];
				let itemIcon = craftItem.icon;
				let itemRarity = craftItem.rarity.toLowerCase();
				
				card.resume()
					.tag('tr')
						.tag('td')
							.tag('img')
								.attr('src', itemIcon)
								.addClass(itemRarity)
								.addClass('ingredient')
							.done()
						.done()
						.tag('td')
							.tag('span')
								.text(`${itemCount}x `)
							.done()
							.addClass(itemRarity)
							.text(itemName)
						.done()
					.done()
					.pause();
			}
		}
		
		document.getElementById('craftingCardsContainer').appendChild(card.resume().allDone());
	}
}

function displayCoins(prefix, coinsObj) {
	let coinp = new html('p')
		.tag('p')
			.text(prefix)
			.pause();
			
	if (coinsObj.gold != 0) {
		coinp.resume()
			.text(' ' + coinsObj.gold)
			.tag('img')
				.attr('src', 'https://wiki.guildwars2.com/images/d/d1/Gold_coin.png')
				.addClass('coinImg')
			.done()
			.pause();
	}
	
	if (coinsObj.silver != 0) {
		coinp.resume()
			.text(' ' + coinsObj.silver)
			.tag('img')
				.attr('src', 'https://wiki.guildwars2.com/images/3/3c/Silver_coin.png')
				.addClass('coinImg')
			.done()
			.pause();
	}
	
	if (coinsObj.copper != 0) {
		coinp.resume()
			.text(' ' + coinsObj.copper)
			.tag('img')
				.attr('src', 'https://wiki.guildwars2.com/images/e/eb/Copper_coin.png')
				.addClass('coinImg')
			.done()
			.pause();
	}
	
	return coinp.resume().done().allDone();
}