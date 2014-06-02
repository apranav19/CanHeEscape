var dataGrid = []; // Initialize an empty array to store blocked cell
var visitedGrid = []; // Initialize an empty array to store path stack

$(document).ready(function(){
	var images = ["car", "tree", "bomb", "bank"]; // An array to store image names
	console.log(visitedGrid); 
	/*
		This function handles an on click event on the play button
	*/
	var idx = 0;
	var vidx = 0;
	$('#play-button').click(function(){

		delayedBlocker();

		// Delay loading the path
		window.setTimeout(delayedTraveler, 5500);
	});


	/*
		Function that slowly colors in the blocked cells
	*/

	function delayedBlocker(){
		var val = dataGrid[idx];
		var cell_id = '#' + 'r' + val.row + 'c' + val.col;
		$(cell_id).hide();
		var rand_img = getImgName();
		var obstacle = "fa-" + rand_img;
		var building = '<i class="fa '+ obstacle + ' fa-3x"></i>';
		$(cell_id).append(building);
		$(cell_id).css("background-color", "#d9534f");
		$(cell_id).fadeIn(500);
		if(++idx == dataGrid.length){
			return true;
		}
		window.setTimeout(delayedBlocker, 1100);
	}

	/*
		Function that slowly colors in the blocked cells
	*/
	function delayedTraveler(){
		var val = visitedGrid[vidx];
		var cell_id = '#' + 'r' + val.row_num + 'c' + val.col_num;
		var kid = "";
		$(cell_id).hide();
		if(vidx == visitedGrid.length-1){
			kid = '<i class="fa fa-child fa-spin fa-3x"></i>';
		}else{
			kid = '<i class="fa fa-child fa-3x"></i>';
		}
		$(cell_id).append(kid);
		$(cell_id).css("background-color", "#5cb85c");
		$(cell_id).fadeIn(700);
		if(vidx != visitedGrid.length-1){
			$(cell_id + " i ").fadeOut(1500);
		}
		if(++vidx == visitedGrid.length){
			popUp();
			return;
		}
		window.setTimeout(delayedTraveler, 1100);
	}

	/*
		This function automates the click event
		on the modal button
	*/
	function popUp(){
		$('#modal-btn').click();
	}

	/*
		This function randomly generates a number between 0-4
		It returns the name of the image from the images array
	*/
	function getImgName(){
		var rand_index = Math.floor((Math.random()*images.length));
		return images[rand_index];
	}
});