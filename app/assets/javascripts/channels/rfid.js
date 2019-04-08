//= require cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();

App.rfid_read = App.cable.subscriptions.create('RfidReadChannel', {
    received: function(data) {
        $("#card").val(data.card);
        $("#accountID").val(data.account_id);
        $('form.autosubmit').submit();
        $('form.autosubmit.disable').removeClass('autosubmit');
        return true;
    }
});

App.publish_backup = App.cable.subscriptions.create('BackupNotifChannel', {
    received: function(data) {
        console.log(data.started);
        if(data.status == 'started'){
            show_loading();
            $('#loaderMessage').html("Yedekleme Başladı...");
        }
        else {
            $('#loaderMessage').html("Yedekleme Başarılı!");
            setTimeout(function(){hide_loading();}, 1000)
        }
        return true;
    }
});
