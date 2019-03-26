//= require cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();

App.rfid_read = App.cable.subscriptions.create('RfidReadChannel', {
    received: function(data) {
        $("#card").val(data.card);
        $('form.autosubmit').submit();
        return true;
    }
});