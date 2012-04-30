
$(function(){
	var currentShow = 0;

	$('.nextshow').live('click', function(){
		var total = $('.showDetails').length;
		if(currentShow+1 < total){
			currentShow++
			$('.showDetails').hide();
			$('.showDetails').eq(currentShow).show();
		}else{
			currentShow = 0;
			$('.showDetails').hide();
			$('.showDetails').eq(0).show();
		}
		$('.currentshow').text(currentShow+1);
		
	})
	
});


