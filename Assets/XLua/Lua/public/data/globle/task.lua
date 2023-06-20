task={
	[20001]={
		id=20001,
		type=1,
		name = "Answer Question",
		intro = "Answer 10 question",
		reward={1,10001,100,},
		goTo={"answer",},
		pic = "answerQuestion",
	},
	[20002]={
		id=20002,
		type=1,
		name = "Plant Mint",
		intro = "Plant a mint",
		reward={2,20001,2,},
		goTo={"mint",},
		pic = "plantMint",
	},
	[20003]={
		id=20003,
		type=1,
		name = "Get Lucky Bag",
		intro = "Play lucky bag 5 times",
		reward={{2,20002,2,1,},{1,10001,100,},},
		goTo={"luckyBag",},
		pic = "getLuckyBag",
	},
	[20004]={
		id=20004,
		type=1,
		name = "Add Cat Food",
		intro = "Add food 3 times",
		reward={1,10001,100,},
		goTo={"food",},
		pic = "addCatFood",
	},
	[20005]={
		id=20005,
		type=1,
		name = "Add Water",
		intro = "Add water 3 times",
		reward={1,10001,101,},
		goTo={"food",},
		pic = "addWater",
	},
	[20006]={
		id=20006,
		type=1,
		name = "Add CatLitter",
		intro = "Add catlitter 3 times",
		reward={1,10001,102,},
		goTo={"toilet",},
		pic = "addCatLitter",
	},
	[20007]={
		id=20007,
		type=1,
		name = "Play with Cat",
		intro = "Play with cat 10 times",
		reward={1,10001,103,},
		goTo={"tips","please select a cat",},
		pic = "playwithCat",
	},
	[20008]={
		id=20008,
		type=1,
		name = "Level Up",
		intro = "Level up 3 times",
		reward={1,10001,104,},
		goTo={"catAttribute",},
		pic = "levelUp",
	},
	[20009]={
		id=20009,
		type=1,
		name = "Get Mint",
		intro = "Get 3 mints",
		reward={1,10001,105,},
		goTo={"mint",},
		pic = "getMint",
	},
	[20010]={
		id=20010,
		type=1,
		name = "Shopping",
		intro = "Go to buy 3 items",
		reward={1,10001,106,},
		goTo={"shop",},
		pic = "shopping",
	},
	[21001]={
		id=21001,
		type=2,
		name = "Complet Task",
		intro = "Complet all tasks",
		reward={1,10001,107,},
		goTo={},
	},
}