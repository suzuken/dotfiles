Hoge.Class = Ext.extend(Fuga, {

    initComponent: function(){

        Ext.applyIf(this, {id: Ext.id()});

        Ext.apply(this, {

        });

        this.onRender = Hoge.Class.superclass.onRender.createSequence(this.onRender);

        Hoge.Class.superclass.initComponent.call(this);

    },

    initEvents: function(){

        Hoge.Class.superclass.initEvents.call(this);

    },

    onRender: function(){

    }
});

Ext.reg('', Hoge.Class);
