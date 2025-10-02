#[starknet::contract]
mod PrivateIdentity {
    use starknet::{ContractAddress, get_caller_address};
    use core::pedersen::pedersen;
    
    #[storage]
    struct Storage {
        // Commitment to identity data (hash)
        identity_commitments: LegacyMap<ContractAddress, felt252>,
        // Zero-knowledge proofs for identity verification
        verified_identities: LegacyMap<ContractAddress, bool>,
        // Age verification without revealing actual age
        age_proofs: LegacyMap<ContractAddress, bool>,
        // Reputation scores (anonymous)
        reputation_scores: LegacyMap<felt252, u32>,
        // Nullifiers to prevent double-spending of proofs
        nullifiers: LegacyMap<felt252, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        IdentityCommitted: IdentityCommitted,
        ProofVerified: ProofVerified,
        ReputationUpdated: ReputationUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct IdentityCommitted {
        user: ContractAddress,
        commitment: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct ProofVerified {
        proof_type: felt252,
        nullifier: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct ReputationUpdated {
        anonymous_id: felt252,
        new_score: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Initialize contract
    }

    #[external(v0)]
    fn commit_identity(ref self: ContractState, commitment: felt252) {
        let caller = get_caller_address();
        self.identity_commitments.write(caller, commitment);
        self.emit(IdentityCommitted { user: caller, commitment });
    }

    #[external(v0)]
    fn verify_age_proof(
        ref self: ContractState,
        proof: felt252,
        nullifier: felt252,
        is_over_18: bool
    ) -> bool {
        // Verify nullifier hasn't been used
        assert(!self.nullifiers.read(nullifier), 'Nullifier already used');
        
        // In real implementation, verify ZK proof here
        // For hackathon demo, we simulate verification
        let verification_result = self._verify_zk_proof(proof, nullifier, is_over_18);
        
        if verification_result {
            let caller = get_caller_address();
            self.age_proofs.write(caller, is_over_18);
            self.nullifiers.write(nullifier, true);
            self.emit(ProofVerified { 
                proof_type: 'age_verification', 
                nullifier 
            });
        }
        
        verification_result
    }

    #[external(v0)]
    fn update_reputation(ref self: ContractState, anonymous_id: felt252, score_delta: u32) {
        // Only verified identities can update reputation
        let caller = get_caller_address();
        assert(self.verified_identities.read(caller), 'Identity not verified');
        
        let current_score = self.reputation_scores.read(anonymous_id);
        let new_score = current_score + score_delta;
        
        self.reputation_scores.write(anonymous_id, new_score);
        self.emit(ReputationUpdated { anonymous_id, new_score });
    }

    #[external(v0)]
    fn generate_anonymous_credential(
        self: @ContractState, 
        user: ContractAddress
    ) -> felt252 {
        // Generate anonymous credential based on identity commitment
        let commitment = self.identity_commitments.read(user);
        assert(commitment != 0, 'No identity commitment found');
        
        // Create anonymous ID using pedersen hash
        let timestamp = starknet::get_block_timestamp();
        pedersen(commitment, timestamp.into())
    }

    #[external(v0)]
    fn verify_membership_proof(
        ref self: ContractState,
        group_id: felt252,
        proof: felt252,
        nullifier: felt252
    ) -> bool {
        // Verify user is member of group without revealing identity
        assert(!self.nullifiers.read(nullifier), 'Nullifier already used');
        
        let verification_result = self._verify_membership_proof(group_id, proof, nullifier);
        
        if verification_result {
            self.nullifiers.write(nullifier, true);
            self.emit(ProofVerified { 
                proof_type: 'membership', 
                nullifier 
            });
        }
        
        verification_result
    }

    #[view]
    fn get_reputation(self: @ContractState, anonymous_id: felt252) -> u32 {
        self.reputation_scores.read(anonymous_id)
    }

    #[view]
    fn is_age_verified(self: @ContractState, user: ContractAddress) -> bool {
        self.age_proofs.read(user)
    }

    // Private helper functions
    fn _verify_zk_proof(
        self: @ContractState,
        proof: felt252,
        nullifier: felt252,
        claim: bool
    ) -> bool {
        // Placeholder for actual ZK proof verification
        // In production, this would use Cairo's built-in proof verification
        true
    }

    fn _verify_membership_proof(
        self: @ContractState,
        group_id: felt252,
        proof: felt252,
        nullifier: felt252
    ) -> bool {
        // Placeholder for membership proof verification
        true
    }
}