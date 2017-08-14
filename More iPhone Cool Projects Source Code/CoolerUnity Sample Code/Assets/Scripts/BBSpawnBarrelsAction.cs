using UnityEngine;
using System.Collections;

public class BBSpawnBarrelsAction : MonoBehaviour {
	
	public GameObject barrelPrefab;

	public void doButtonAction()
	{
		// are there any spawned barrels left?
		if (GameObject.Find("Spawned Barrel") != null) return;

		// We want to spawn some barrels
		this.spawnBarrelAtPoint(new Vector3(10.0f,1.5f,10.0f));
		this.spawnBarrelAtPoint(new Vector3(-10.0f,1.5f,-10.0f));
	}
	
	void spawnBarrelAtPoint(Vector3 spawnPoint) 
	{
		// spawn a barrel and name it so we can find it later
			GameObject newBarrel = (GameObject)Instantiate(barrelPrefab,spawnPoint,Quaternion.identity);
			newBarrel.name = "Spawned Barrel";
	}
}
