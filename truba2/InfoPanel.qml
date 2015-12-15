Item {
	id: infoPanelProto;
	property variant channel;
	height: renderer.height / 5;
	anchors.left: parent.left;
	anchors.right: parent.right;
	anchors.bottom: parent.bottom;
	anchors.margins: 10;
	visible: false;
	focus: visible;

	Rectangle {
		id: currentChannelBg;
		height: parent.height;
		width: height;
		anchors.top: parent.top;
		anchors.left: parent.left;

		Image {
			id: currentChannelLogo;
			anchors.fill: parent;
			anchors.margins: 10;
			fillMode: Image.PreserveAspectFit;
		}
	}

	Rectangle {
		color: colorTheme.focusablePanelColor;
		anchors.top: parent.top;
		anchors.left: currentChannelBg.right;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;

		MainText {
			id: currentChannelTitle;
			anchors.top: parent.top;
			anchors.left: parent.left;
			anchors.margins: 10;
			font.bold: true;
			color: colorTheme.accentTextColor;
		}

		MainText {
			id: currentProgramTitle;
			anchors.left: parent.left;
			anchors.top: currentChannelTitle.bottom;
			anchors.topMargin: 5;
			anchors.leftMargin: 10;
			anchors.rightMargin: 10;
			color: colorTheme.textColor;
		}

		Item {
			height: 5;
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.top: currentProgramTitle.bottom;
			anchors.margins: 5;

			Rectangle {
				id: currentProgramProgress;
				property real progress;
				width: progress * parent.width;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
				color: colorTheme.accentColor;
			}
		}

		SmallText {
			id: currentProgramDescriptionText;
			anchors.top: currentProgramProgress.bottom;
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;
			anchors.margins: 5;
			color: colorTheme.textColor;
			wrap: true;
		}
	}

	BorderShadow { }

	Timer {
		id: updateTimer;
		interval: 10000;
		running: parent.visible;
		repeat: true;

		onTriggered: { infoPanelProto.updateProgress() }
	}

	updateProgress: {
		var program = this.channel.program;
		if (!program || !program.start)
			return

		currentProgramTitle.text = program.start + (program.start ? "-" : "") + program.stop + " " + program.title;
		log("ds", program.description)
		currentProgramDescriptionText.text = program.description

		var currDate = new Date();
		var start = program.startTime
		var stop = program.stopTime
		currentProgramProgress.progress = (currDate.getTime() - start.getTime()) / (stop.getTime() - start.getTime())
	}
	
	onBackPressed: { this.hide() }

	hide: { this.visible = false }

	show(channel): {
		if (!channel) {
			log("channel is null")
			return
		}

		this.visible = true
		this.channel = channel

		currentChannelBg.color = channel.color
		currentChannelTitle.text = channel.text
		currentChannelLogo.source = channel.source
		this.updateProgress()
	}
}