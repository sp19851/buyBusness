const App = {

    /*data() {
        return {
          show: false,
          street1: "",
          street2: "",
          showCompass: true,
          showStreets: true,
          showPointer: true,
          showDegrees: true,
        };
      },*/
    data() {
        return {
            show: false,
            _self: '',
            modalWindowShoing: false,
            dialogContent: '',
            tab: 0, 
            disable: false,
            componentKey: 0,
            storage: [ // склад
                /*{"id":"2","name":"shop9046","label":"Магазин дешевых продуктов","owner":"CRUSO01","price":"100"},
                {"id":"3","name":"gas3051","label":"Заправка \"У Билла\"","owner":"MYM03384","price":"100"},
                {"id":"4","name":"transport","label":"Склад ТК","owner":"LKU40805","price":"100"},
                {"id":"6","name":"vu","label":"ВаниллаЮникорн","owner":"","price":"100"},
                {"id":"10","name":"tll","label":"Tequi-la-la","owner":"FOI18854","price":"100"},
                {"id":"11","name":"yj","label":"YellowJack","owner":"FOI18854","price":"100"}*/
            ] , 
            passedData:{item:null, type:null}
        };
        
    },
    components: {},
    methods: {
       
        

        showingForm(bool, data, citizenid) {
            //console.log('funct showingForm', bool, data, citizenid)
            this.show = bool;
            this.storage = data;
            this._self = citizenid;
        },
        getItems(){
            return this.storage;
        },
        isShop(find_string){
            //console.log(' isShop(find_string)', find_string.indexOf('shop'))
            if (find_string.indexOf('shop') != -1) {
                return true
               }{
                   return false
               }

        },
        isGas(find_string) {
            if (find_string.indexOf('gas') != -1) {
               return true
              }{
                  return false
              }
        },
        isOwner(owner) {
            //console.log(this._self, owner)
            if (this._self === owner) {
                return true
            }{
                return false
            } 
            
        },
        are_you_sure(type, item) {
            //console.log('are_you_sure', type, item)
            if (type == 'buy') {
                this.dialogContent = 'Вы уверены, что хотите купить этот бизнес за $'+item.price;
            } else {
                this.dialogContent = 'Вы уверены, что хотите продать этот бизнес за $'+ Math.round(item.price/2);
            } 
            this.passedData.item = item;
            this.passedData.type = type;
            this.modalWindowShoing = true;
        },
        
        btnAccept() {
            //console.log('btnAccept', this.passedData.item, this.passedData.type)
            $.post('http://buyBusness/update', JSON.stringify({type:this.passedData.type, id:this.passedData.item.id}), function(data) {
                /*$.each(data, function(index, value) {
                    console.log('data', index, value.id, value.name, value.owner, value.owner.length)
                });
                console.log('Загрузка завершена.');
               */
                
            });
            //this.onClose()
            this.modalWindowShoing = false;
   
        },
        btnCancel() {
            this.modalWindowShoing = false;
            
        },
        onClose() {
            this.show = false;
            $.post('https://buyBusness/close');

        }
    },

    mounted() {
        //console.log('mounted', this.show, show, modalWindowShoing, _self)
        this.listener = window.addEventListener("message", (event) => {
            //console.log('test window.addEventListener', event.data.action)
            if(event.data.action === 'open') {
                this.showingForm(event.data.bool, event.data.items, event.data.citizenid);
                // event.data
            } else if(event.data.action === 'close') {
                this.onClose()
            } else if(event.data.action === 'refresh') {
                this.storage = event.data.items

            }
            
        });
        window.document.onkeydown = event => event && event.code === 'Escape' ? this.onClose() : null
      },


    

    /*created() {
        
        let el = this;
        //console.log('created', el.show, show, modalWindowShoing, _self)
        let onClose = () => {
            el.show = false;
        }
        window.addEventListener('message', function(event) {
            console.log('event.data.action', event.data.action)
          
            if(event.data.action === 'open') {
                this.showingForm(event.data);
                // event.data
            } else if(event.data.action === 'close') onClose()
        })
        window.document.onkeydown = event => event && event.code === 'Escape' ? onClose() : null
    }*/
}

let app = Vue.createApp(App)
app.mount('#app')