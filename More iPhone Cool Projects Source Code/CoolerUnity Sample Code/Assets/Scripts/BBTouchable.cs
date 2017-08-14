using UnityEngine;
using System.Collections;

public class BBTouchable : MonoBehaviour {

	public virtual void handleTouch(Vector3 worldPoint) {
		// call the static character ref and tell it to go to the point
		BBCharacterController.instance.moveTowards(worldPoint);
	}
}
