class html {
	constructor(str, parent) {
		this.parent = parent;
		this.element = document.createElement(str);
		this.lastSave = null;
		return this;
	}
	
	//append nodes
	node(element) {
		this.element.appendChild(element);
		return this;
	}
	
	text(str) {
		let textNode = document.createTextNode(str);
		this.element.appendChild(textNode);
		return this;
	}
	
	newline() {
		this.element.appendChild(document.createElement('br'));
		return this;
	}
	
	//Create child html object
	tag(str) {
		return new html(str, this);
	}
	
	attr(a, b) { //a must be string or object
		if (typeof a === 'string') {
			this.element.setAttribute(a, b);
		} else {
			for (let name of Object.keys(a)) {
				this.element.setAttribute(name, a[name]);
			}
		}
		return this;
	}
	
	getAttr(name) {
		return this.element.getAttribute(name);
	}
	
	addClass(str) {
		this.element.classList.add(str);
		return this;
	}
	
	hasClass(str) {
		return this.element.classList.contains(str);
	}
	
	removeClass(str) {
		this.element.classList.remove(str);
		return this;
	}
		
	css(a, b) { //a must be string or object.
		if (typeof a === 'string') {
			this.element.style[a] = b;
		} else {
			for (let name of Object.keys(a)) {
				this.element.style.setProperty(name, a[name]);
			}
		}
		return this;
	}
	
	cssText(rawCSS) {
		this.element.style = rawCSS;
		return this;
	}
	
	//saves the current object
	pause() {
		const save = this;
		let root = save;
		while (root.parent != null) {
			root = root.parent;
		}
		root.lastSave = save;
		return root;
	}
	
	//returns to the last saved object
	resume() {
		let saved = this.lastSave;
		this.lastSave = null;
		return saved;
	}
	
	//append current node to parent node and return to parent object
	done() {
		this.parent.element.appendChild(this.element);
		return this.parent;
	}
	
	//turn current html object into a node
	allDone() {
		return this.element;
	}
}