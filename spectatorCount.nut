void function spectatorCount() {
	
	float functionref(float, float) calcAngleDiff = float

	function(float angle1, float angle2) {
		float diff = angle1 - angle2;
		if (diff > 180) {
			diff -= 360;
		} else if (diff <- 180) {
			diff += 360;
		};
		//make diff positive
		if (diff < 0) {
			diff *= -1;
		};
		return diff;
	};

	//could be a struct but whatever
	array < int > lastUpdateTimes;
	array < float > lastAngleDeltas;
	array < string > lastNames;

	//resize to 100 so we dont go out of bounds
	//100 just in case lmao
	lastUpdateTimes.resize(100);
	lastAngleDeltas.resize(100);
	lastNames.resize(100);

	entity localview = GetLocalViewPlayer();
	if (IsValid(localview)) {
		string announcement = "Spectator Count Started";
		string subText = "Created By: KrahnB3rry";
		AnnouncementMessage(localview, announcement, subText, titleColor, 0);
	}

	while (true) {
		entity localPlayer = GetLocalClientPlayer();
		//end thread on localplayer destroy
		EndSignal(localPlayer, "OnDestroy");
		if (IsValid(localPlayer)) {


			array < entity > players = GetPlayerArrayIncludingSpectators();

			string Str = "Spectators: \n";

			for (int i = 0; i < players.len(); i++) {
				entity player = players[i];
				if (player == localPlayer) {
					continue;
				}
				//get angle delta from local angles
				float angleDelta = calcAngleDiff(player.EyeAngles().y, localPlayer.EyeAngles().y);
				if (IsAlive(player) == false) {
					//for some reason u cant just go localAngles == playerAngles
					if (angleDelta < 0.1) {
						lastUpdateTimes[i] = GetUnixTimestamp();
					}
				}
				lastAngleDeltas[i] = angleDelta;
				lastNames[i] = player.GetPlayerName();
			}

			int count = 0;
			for (int i = 0; i < lastUpdateTimes.len(); i++) {
				if (GetUnixTimestamp() - lastUpdateTimes[i] < 3) {
					Str += lastNames[i] + ": " + lastAngleDeltas[i] + "\n";
					count++;
				};
			};

			//can use this variable in other threads
			//someStruct.spectators = count;

      //make sure the $"" isnt $ "" or game go bye bye
			AddPlayerHint(0.1, 0.1, $"", Str);
		};
		WaitFrame();
	};
}
