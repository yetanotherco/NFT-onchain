#[starknet::interface]
trait IYASMeme<TContractState> {
    fn get(self: @TContractState, token_id: u256);
}

#[starknet::contract]
mod YASMeme {
    use super::IYASMeme;


    #[storage]
    struct Storage {
        
    }

    #[external(v0)]
    impl YASMemeImpl of IYASMeme<ContractState> {
        fn get(self: @ContractState, token_id: u256) {

        }
    }
}
