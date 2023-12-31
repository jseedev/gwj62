extends Node


var captions = {
	call1 = [
		"Errol: Did you—\nCandy: Hello?",
		"Errol: Hello?\nCandy: Dad.",
		"Errol: Hello?", 
		"Candy: Dad. I’m here.", 
		"Errol: Did you take the CRV to the mechanic?", 
		"Candy: When was I supposed to do that? I've got class till 3:30, and don't get off until 5:15.", 
		"Errol: Afterwards?",
		"Candy: Your pals close at 5:30. Could've gotten it fixed last month if you'd let me take it to the dealership.", 
		"Errol: The stealership? Would have ripped you off big.", 
		"Candy: It's right down the street, but instead I've got to drive all the way to your private shop in Maple Grove every time.",
		"Paid more in gas than it would've cost to fix it.", 
		"Errol: Fine, waste your money. \nErrol: How are you?",
		"Candy: Not as good as I was before this phone call! Only six minutes before the lunch break is over. So that's what you called about?", 
		"Errol: No... just to hear your voice sometimes. About to head out to the field.", 
		"Candy: How many pumpkins are ready?", 
		"Errol: Oh, I thought I'd leave them in the ground some to let them grow.", 
		"Candy: You planted the seeds, when, in July?", 
		"Errol: June.\nCandy: They're ready!", 
		"Errol: I know, I just...\nCandy: What?", 
		"Errol: Was hoping you and the tykes would come out and help me pick them. Get a fun day out of it.", 
		"Candy: It's an hour-and-a-half from Minneapolis.", 
		"Errol: On the weekend?", 
		"Candy: The kids have friends, dad. They were playing this, I don't know, Tears of the Kingdom or something or other on the Nintendo Wii.", 
		"Errol: Switch.", 
		"Candy: Huh?", 
		"Errol: The Nintendo Switch. The one I bought got so riddled with dust that I locked it up in the cupboard. Five hundred bucks with the games for nothin’. Wasn’t enough to get you to bring ‘em over every weekend.", 
		"Errol: ... It's just, I don't know how many more of these seasons I have. I want to spend it with you all. With yours. To see what it was all for, and know it was worth it.", 
		"Candy: Oh because you're soooo close to the end at 59.", 
		"Errol: Candy—I've... the things that I did back in the service, you know what I’m talking about? You know I did them for you, right? To make sure you'd have the life you do right now. The wedding. The down-payment on your condo. It was all to secure your position in life, so you could do the same for your kids.", 
		"Candy: Huh?", 
		"Errol: Haha, never mind, I'm just... lonely—getting stir crazy out here. Nothing much to do except stew in your own thoughts. Stew like caribou soup with chopped up carrots and green onions and black beans, remember how much you liked that when you were a little girl?", 
		"Candy: No.", 
		"Errol: You used to love it every winter. Those times… I think about those times all the time. What I wouldn’t give. Anyway. How’s your mom?", 
		"Candy: I’ve gotta go. Look dad, if it’s too much trouble, I can get the pumpkins from the Walmart. They’re a buck fifty each, and I need one for Alex, Mandy, and Caroline, and maybe another eighteen for my class, so, thirty bucks or so?", 
		"Errol: Thirty-one and a half. You teach multiplication to the second-graders, don’t you?", 
		"Candy: That’s third-grade material, and I can’t calculate when I’m running to class. About the same as the cost of gas for you to come here tomorrow.", 
		"Errol: No, no. It’s no problem. What else am I going to do.", 
		"Candy: Got to go, dad! Bye!"
	],
	call2 = [
		"Errol: You get the Monsanto shipment yet?", 
		"Holo: Yeah, I got it.", 
		"Errol: Damn, so why aren’t they here yet? Must’ve gotten a flat or somethin’.", 
		"Holo: Mmm.", 
		"Errol: Why so glum, chum?", 
		"Holo: I don’t know.", 
		"Errol: You do know, spill it Holo.", 
		"Holo: Yea … I’m off. I don’t know. Just feel like jumping into the sky and ripping apart the clouds before it rains.", 
		"Errol: Oh, the PTSD syringe, attacking random pores of the soul. Take a nap. Not raining today anyway. You take your meds?", 
		"Holo: It’s not that.", 
		"Errol: It’s always that. You see your Quack recently.", 
		"Holo: I haven’t seen no damn doctors recently.", 
		"Errol: Well, there’s your problem. Can’t fix an engine without tools.", 
		"Holo: Huh?", 
		"Errol: I don’t know what to tell ya. Farmlife ain’t for everyone. Gotta find some joys in life. Take me for example. Going to see my grandkids tomorrow. Carve some of these pumpkins lyin’ around. Two bucks worth of seeds creating memories that make this life all worth it.", "Holo: Whatever.", "Errol: Don’t envy. Be inspired. Go out and start a family. You’ve earned it.", "Holo: You’re just… delusional as all hell. Living a lie.", "Errol: Listen Bart. You’re my lieutenant, and my protégé, and deeper yet my pal, and I guess my neighbour too. I like you, but you’re talkin’ a whole lotta nonsense today. Get with it, or don’t. Dismissed, private."
	],
	call3 = [
		"Errol: Hey Candy-bun, out catchin’ your pumpkins. Just wanted to—", 
		"Candy: Dad—I’m in class! Emergencies only.", 
		"Errol: Oof, sorry, sorry, I forgot!", 
		"Candy: Off in an hour.." , 
		"Errol: An hour? She’s only been in the afternoon shift for a few minutes?"
	],
	call4 = [
		"Errol: I told you it wouldn’t rain today. You’re always putting chips on zeros at the roulette table.\nHello?",
		"Holo: Today’s the day…", 
		"Errol: If you’re anticipatin’ for some nighttime rain, then you best be out on the fields sowing your little ass off. I’m half-an-hour down the road, but if you think I’m drivin’ your combine again, when I got all this business of my own—", 
		"Holo: It’s happening. I told you it would.", 
		"Errol: What is?", 
		"Holo: My house is missing.", 
		"Errol: What?", 
		"Holo: I came back from the mowing around the barn, and the house. Is. Not. There. There’s just a brown square with rounded corners where it used to be.", 
		"Errol: Huh? Well what happened?!", 
		"Holo: It’s all catching up to us, man. You were the lieutenant-colonel! You were supposed to protect me. You put all these demons in my soul. I can’t live with myself anymore. I’m gonna do it.", 
		"Errol: Holo, Holo, Holo. Private Bartholomew Simpson. “Bart Simpson,” remember how much you hated—", 
		"Holo: I’m going to kill myself!", 
		"Errol: … Then go aheeead. Do it.\nI’ve been hearing that stupidity for years now. Stop for a second, and listen to me. Did you take the Thorazine today?", 
		"Holo: Nooo…", 
		"Errol: What about the benztropine, prednisone, Tylenol 3, the somas?", 
		"Holo: Nooooo….", "Errol: And you’re off-cycle on the steroids too?", 
		"Holo: The drugs only cloud the world. They cover what we actually are.", 
		"Errol: That’s exactly what they do. What was the point of me hooking you up with my stock doc, and negotiating a discount for you? The idea here is to distract and numb until the end of your days. After you die, it won’t matter anymore. We become dust and maggot food. Just like they did. There’s a beautiful equality to it all.", 
		"Holo: What we did at Abu Ghraib—", 
		"Errol: Ahh! I don’t want to hear it!", 
		"Holo: … to those Iraqi prisoners. The cutting, the rape, the humiliation!", 
		"Errol: If you don’t shut your Goddamn mouth, I am going to come down there and bury your ungrateful ass in the same hole you think your house got swallowed up into.",
		"Errol: I can’t be bothered with this. I have important things to do today. Take a walk around, get your head together, go in your house, and take the medication that’s been prescribed to you. They’ll make you feel good and healthy, and you’ll get back on your feet. May miss the last of the seeds, but harvesting season is over anyhow.", 
		"Holo: … okay, okay.", 
		"Errol: Good… And by the way. Now that you brought it up, remember this. Those dogs got exactly what they deserved. We toughen brown goo from the kick of our shoe. Remember? And if the shoe was on the other foot, don’t you think they would’ve done it to us?", 
		"Holo: They weren’t on our soil. We were on theirs!", 
		"Errol: Enough treachery! You’re a goddamn American with service stripes, start acting like one."
	],
	call5 = [
		"Candy: So what did you want?", 
		"Errol: The pumpkins are a little soft this season. May not hold to carving.", 
		"Candy: That’s fine. If they do, they do. If they don’t, you get replaced by the Walton family next year.", 
		"Errol: Anyway .. So how’s everything with you?", 
		"Candy: How many times are you going to ask me that?", 
		"Errol: I just wanna know. You used to come through the front door everyday not too long ago. Go right up to your room and drop your backpack in the closet, not touching it until the morning  after. You hated homework. Now you’re assigning it.", 
		"Candy: That was twenty-one years ago dad. Before you got deployed. A lot’s happened since.", 
		"Errol: Yeah, but feels like last week. Feels like you went on a school trip to Kearney and never came back.", 
		"Candy: Actually, it feels like you went to Abu Ghraib and never came back.", 
		"Errol: … Candice, you know about all that stuff over there, right? By now?", 
		"Candy: I knew it then.\nErrol: Yeah.\nCandy: Yeah.", 
		"Errol: … And? What does it make with you?", 
		"Candy: You came back a different person anyway. Like there were three of you inside with drastically different moods trying to compete over one body. Trying to say three different things at once. Then you started seeing the psychiatrist, and you took medication, and calmed down, and were like calm and happy and overly-enthusiastic but then you moved out to the farm and got away from us. Why?", 
		"Errol: You know about the things I did over there?", 
		"Candy: I know a little. Before I didn’t want to know anymore.", 
		"Candy: I think I have to go now.", 
		"Errol: All these leaves.", 
		"Candy: What?", 
		"Errol: These dead autumn leaves. Nothing more useless in this world than something that was nice and green once, then falls and slowly loses its colour.", 
		"Candy: Is that your off-handed way of saying I’m being a bitch?", 
		"Errol: No. I’m just saying there are a lot of leaves on the ground and I could either go pick up the rest of your stupid pumpkins or rake them up since they could be covering pits, and once you fall into a hole where there’s no one around, you die a slow, painful death like these ugly red and orange leaves themselves, and nobody hears your screams because nobody cares.", 
		"Candy: Okay, don’t bother coming tomorrow. Bye.", 
		"Errol: You said “bye” to me a long time ago."
	],
	holo_voicemail = 
	[
		"The vengeful ghost of those who we tortured has found our hidden place in the world.", 
		"They bring the pain that we cultivated, and their blood has fertilized the fields of anger.", 
		"And it’s grown. They will cut right through us, and continue in the world causing more horrors.", 
		"That was our contribution to this world.", 
		"We doused gasoline on the fires of Hell, and laughed while we did it.", 
		"We doused gasoline on those poor Iraqis. It did nothing to our moral fiber because we didn’t have any.", 
		"We are demons infesting bodies. No empathy, no compassion, no reason to exist.", 
		"Evil incarnate.", 
		"Our only gesture is to give ourselves willingly to the Shabh of Abu Ghraib.", 
		"It may then spare our families."
	],
	errol_voicemail1 =[
		"Hey Holo. No point in leaving this message.", 
		"But I never got to say I was sorry. We got off scot-free in the investigation.", 
		"It was wrong, and you were right. These pills do obscure reality.", 
		"The penance was always the cure for the guilt.", 
		"But still - wouldn’t make it right. We made mistakes in life that were so severe they were unforgivable.", 
		"After it’s all over, if there’s a chance we can—I don’t know. I know what feels right though.", 
		"What you said this morning. But we didn’t have that conversation this morning, did we?", 
		"We had it the week before you took your life in 2007.", 
		"I’d imagined us in, I don’t know. Some sort of happily ever after.", 
		"Numbing our mutual sorrows. Throwing leaves over pits."
	],
	errol_voicemail2 = [
		"Errol: (clearing of throat) My sweet Candice. I’m sorry about earlier.", 
		"I’m sorry about everything. I’m so sorry I took enjoyment in other people’s pain.", 
		"And I’m sorry I’ve been covering up my own since.", 
		"I know you don’t want to talk to me right now, and I don’t blame you.", 
		"You deserved a better father than what you got in this life.", 
		"And if I stand here and tell you “I love you” and that I love my grandchildren,", 
		"I wouldn’t know if that would be affection or more bullets thrown towards innocent people I was sworn to protect.", 
		"I just don’t know how this life went the way it did.", 
		"I just know that I’ll be leaving it with an understanding of what was right and what was wrong, if that means anything.", 
		"You were the best daughter I could ever hope for. I have to go now.", 
		"I—have to go rake these leaves."
	],
	errol_missed1 = [
		"Hey man. Give me a ring. Thanks."
	],
	errol_missed2 = [
		"Holo. You know I love ya, right?\nTough love is sometimes what's needed. Let's talk before today ends."
	],
	errol_missed3 = [
		"Call me IMMEDIATELY. That's an ORDER."
	]
}

var on_caption = 0
func next_caption():
	var cid = $AnimationPlayer.current_animation
	if captions.keys().has(cid) and captions[cid].size()-1 >= on_caption:
		$Control/Captions.text=captions[cid][on_caption]
	on_caption+=1

func clear_caption():
	$Control/Captions.text=""
