using UnityEngine;
using System.Collections;

public class RotateBarrel : MonoBehaviour {

	public float speed = 1.0f;

	// Use this for initialization
	void Start () {
		gameObject.transform.rotation = Quaternion.identity;
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate(Vector3.right, speed);
	}
	
	// // This is for the coroutine version
	// void Start () {
	// 	gameObject.transform.rotation = Quaternion.identity;
	// 	StartCoroutine(this.periodicRotate());
	// }
	// 
	// void periodicRotate () {
	// 	while (1) {
	// 		transform.Rotate(Vector3.right, speed);
	// 		yield return new WaitForSeconds (0.1f);
	// 	}
	// }
	
}
