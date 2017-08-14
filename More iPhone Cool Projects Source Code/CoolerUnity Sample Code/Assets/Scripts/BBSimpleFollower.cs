using UnityEngine;
using System.Collections;

public class BBSimpleFollower : MonoBehaviour {
	public GameObject target;
	private Vector3 offset;

	void Start() 
	{
		// set the fixed offset to whatever it is at the start
		offset = transform.position - target.transform.position;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		// lag behind  by a few frames to make it look smooth
		transform.position = Vector3.Lerp(transform.position,target.transform.position + offset,0.1f);
	}
}
