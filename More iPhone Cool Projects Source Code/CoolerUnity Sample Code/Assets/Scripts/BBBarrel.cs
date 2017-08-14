using UnityEngine;
using System.Collections;

// This class extends the attackable class by adding in an explosion when
// the barrel is destroyed

public class BBBarrel : BBAttackable {
	
	public GameObject explosionPrefab;

	public override void die()
	{
		// need to play a death animation or something
		// for now, we will just destroy
		Instantiate(explosionPrefab,transform.position,Quaternion.identity);
		Destroy(gameObject);
	}
}
