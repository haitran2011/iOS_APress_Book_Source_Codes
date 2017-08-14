using UnityEngine;
using System.Collections;

public class BBTouchableButton : BBTouchable {

	public GameObject buttonDelegate;
	public string message = "doButtonAction";

	public override void handleTouch(Vector3 worldPoint) 
	{
		// if our delegate is null, then send the message to ourselves
		if (buttonDelegate == null) buttonDelegate = gameObject;
		buttonDelegate.SendMessage(message,SendMessageOptions.DontRequireReceiver);	
	}
}
