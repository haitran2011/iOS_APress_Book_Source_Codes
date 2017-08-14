using UnityEngine;
using System.Collections;

// BBAttackable adds attackable functionality to any touchable object
// your object requires a collider for this to function properly

public class BBAttackable : BBTouchable {

	public float armor = 0.0f; // higher armor is harder to hit
	public float health = 1.0f; // at health = 0 i am dead

	public override void handleTouch(Vector3 worldPoint) 
	{
		// this will cause the player to attack me
		BBCharacterController.instance.attack(this);
	}
	
	public virtual void applyDamage(int damage) 
	{
		health -= damage;
		if (health <= 0) this.die();
	}
	
	public virtual void die()
	{
		// need to play a death animation or something
		// for now, we will just destroy
		Destroy(gameObject);
	}
}
