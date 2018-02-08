var emitter = require('events');

var event = new  emitter.EventEmitter();
event.on('log',function(){
    console.log('log .....')
});
event.once('once',function(){
    console.log('once .....')
});

setInterval(()=>{
    event.emit('log');
    event.emit('once');
},1000)