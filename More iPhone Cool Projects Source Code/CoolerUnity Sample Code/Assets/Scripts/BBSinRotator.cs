using UnityEngine;
using System.Collections;

// this class is a simple rotation script that will rotate
// back and forth around a specified axis using 
// the sin fuction to calculate the movement

public class BBSinRotator : MonoBehaviour {

	public float degreesPerSecond = 90.0f;
	public float cycleDuration = 4.0f;
	public Vector3 rotationAxis = Vector3.up;

	void Start () 
	{
		StartCoroutine(this.rotate());
	}
	

	IEnumerator rotate () 
	{
		float phi,amplitude;
		
		while (true) {
			phi = Time.time / cycleDuration * 2.0f * Mathf.PI;
			amplitude = Mathf.Sin( phi );			
			transform.Rotate(rotationAxis * Time.deltaTime * degreesPerSecond * amplitude);
			yield return new WaitForSeconds (0.1f);
		}
	}
}
