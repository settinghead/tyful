package polartree.PolarTree
{
     import flash.events.Event;
     public class PolarTreeEvent extends Event
     {
          //the event type ON_ADD_CONTACT is used when a contact is added to our list
          public static const ON_SLAP_REQUEST:String = "onSlapRequest";
          /* the event type ON_REMOVE_CONTACT is used when, surely, a contact is deleted */
          public static const ON_FEED_REQUEST:String = "onRemoveContact";
          /*customMessage is the property will contain the message for each event type dispatched */
          public var customMessage:String = "";

          public function PolarTreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
          {
               //we call the super class Event
               super(type, bubbles, cancelable);
          }
     }
}
