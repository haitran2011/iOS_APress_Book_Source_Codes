using UnityEngine;
using System.Collections;

// the character controller is the heart of the game interactions
// it controls our main character model
// Note: Adam Taylor <http://adamtaylorfolio.com> built the animations that we
// are using in this code.

public class BBCharacterController : MonoBehaviour {

	// a few character attributes.
	public float moveSpeed = 7.0f;
	public float attackRange = 5.0f; // if this is set too low, you wont be able to attack anything
	public int attackDamage = 5; 
	
	public GameObject cursor;
	public GameObject characterModel;
		
	private Vector3 movementDestination;
	private CharacterController controller;

	private static BBCharacterController sharedInstance = null;
	
	// our static accessor. this way we always get the same character controller back
	public static BBCharacterController instance {
	    get {
	        if (sharedInstance == null) {
	            sharedInstance = FindObjectOfType(typeof (BBCharacterController)) as BBCharacterController;
	            if (sharedInstance == null)
	                Debug.Log ("Could not locate a BBCharacterController object. You have to have exactly one BBCharacterController in the scene.");
	        }
	        return sharedInstance;
	    }
	}

	// init our instance variables and setup the animations
	void Start () 
	{
		movementDestination = transform.position;
		controller = (CharacterController)gameObject.GetComponent(typeof(CharacterController));
	
		if (characterModel != null) {
			characterModel.animation.wrapMode = WrapMode.Loop;
			characterModel.animation["Attack"].wrapMode = WrapMode.Once;
			characterModel.animation["Attack"].layer = 1;			
		}
	}
	
		// Update is called once per frame
	void Update () {
		// figure out our movement vector
		Vector3 moveDirection = movementDestination - gameObject.transform.position;
		moveDirection.y = 0.0f;
	
		// if we are moving, then do so, and play the walk animation
		// otherwise play the idle one
		if (moveDirection.sqrMagnitude > 0.5) {
			controller.Move(moveDirection.normalized * Time.deltaTime * moveSpeed);			
			if (characterModel != null) characterModel.animation.CrossFade ("Walk");
		} else {
			if (characterModel != null) characterModel.animation.CrossFade ("Idle");
		}
	}

	// this is generally called by external scripts to tell
	// us that we should attempt to move to the specified point
	public void moveTowards(Vector3 position) 
	{
		position.y = 0.0f;
		movementDestination = position;
		transform.LookAt(position);
		position.y = 0.1f;
		if (cursor != null) cursor.transform.position = position;	
	}
	
	// when we hit things, we should stop.
	void OnControllerColliderHit (ControllerColliderHit hit)
	{
		movementDestination = gameObject.transform.position;
		movementDestination.y = 0.0f;
		if (cursor != null) {
			Vector3 cursorPosition = movementDestination;
			cursorPosition.y = 0.1f;
			cursor.transform.position = cursorPosition;			
		}
	}

	// attack checks first to see if we are within range
	// and if so, it plays the attack animation
	// and doles our damage
	public void attack(BBAttackable target)
	{
		// first off, am I close enough to hit it?
		// if not, then move towards it
		if (Vector3.Distance(transform.position, target.transform.position) > attackRange) {
			this.moveTowards(target.transform.position);
			return;
		}
		Vector3 lookAt = target.gameObject.transform.position;
		lookAt.y = 0.0f;
		transform.LookAt(lookAt);
		if (characterModel != null) characterModel.animation.CrossFade ("Attack");
		StartCoroutine(this.doDamage(target));
	}
	
	// just a delayed call so that the damage is sent out when the animation is
	// at the right point
	IEnumerator doDamage(BBAttackable target)
	{
		yield return new WaitForSeconds (1.0f);
		if (target != null) target.applyDamage(attackDamage);
	}
	
}
