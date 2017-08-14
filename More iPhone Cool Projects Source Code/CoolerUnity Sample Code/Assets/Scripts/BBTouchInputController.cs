using UnityEngine;
using System.Collections;

public class BBTouchInputController : MonoBehaviour {
	
	public Camera GUICamera;

	void Update () {
		if (Input.GetMouseButton(0)) {
			Vector2 touch = new Vector2(Input.mousePosition.x,Input.mousePosition.y);
			this.handleTouchAtPointForAllCameras(touch); // this is if you have more than one camera
//			this.handleTouchAtPoint(touch);
		}
	}

	public void handleTouchAtPoint(Vector2 touchPoint) {
		RaycastHit hit = new RaycastHit();
		if (Physics.Raycast(Camera.main.ScreenPointToRay(touchPoint),out hit, Mathf.Infinity)) {
			BBTouchable touchableObject = (BBTouchable)hit.transform.gameObject.GetComponent(typeof(BBTouchable));
			if (touchableObject != null) touchableObject.handleTouch(hit.point);
		}
	}

	public void handleTouchAtPointForAllCameras(Vector2 touchPoint) {
		// check the gui cam first, and if it finds something, then
		// dont bother checking the scene camera
		if (this.cameraDidHandleTouch(GUICamera,touchPoint)) return;
		this.cameraDidHandleTouch(Camera.main,touchPoint);
	}

	public bool cameraDidHandleTouch(Camera cam, Vector2 touchPoint) {
		RaycastHit hit = new RaycastHit();
		if (Physics.Raycast(cam.ScreenPointToRay(touchPoint),out hit, Mathf.Infinity)) {
			BBTouchable touchableObject = (BBTouchable)hit.transform.gameObject.GetComponent(typeof(BBTouchable));
			if (touchableObject != null) {
				touchableObject.handleTouch(hit.point);
				return true;
			}
		}
		return false;		
	}
	
}
