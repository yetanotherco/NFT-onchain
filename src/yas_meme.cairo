use starknet::{ContractAddress};
// use alexandria_math::Storage::List;
// use alexandria_storage::List;
use alexandria_storage::list::{List, ListTrait};


#[starknet::interface]
trait IYASMeme<TContractState> {
    fn mint(
        ref self: TContractState,
        owner: ContractAddress,
        content: Array<felt252>,
        title: felt252,
        file_extension: felt252
    );
    fn read_content(self: @TContractState) -> Array<felt252>;
    fn read_owner(self: @TContractState) -> ContractAddress;
    fn gift(ref self: TContractState, new_owner: ContractAddress);
    fn read_title(self: @TContractState) -> felt252;
    fn read_caption(self: @TContractState) -> felt252;
    fn write_caption(ref self: TContractState, new_caption: felt252);
    fn read_file_extension(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod YASMeme {
    use super::IYASMeme;
    use starknet::{ContractAddress, get_caller_address};
    use alexandria_storage::list::{List, ListTrait};


    #[storage]
    struct Storage {
        title: felt252,
        content: List<felt252>,
        owner: ContractAddress,
        caption: felt252,
        file_extension: felt252 //.bmp, .png, etc
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }


    #[external(v0)]
    impl YASMemeImpl of IYASMeme<ContractState> {
        fn mint(
            ref self: ContractState,
            owner: ContractAddress,
            content: Array<felt252>,
            title: felt252,
            file_extension: felt252
        ) {
            assert(get_caller_address() == self.owner.read(), 'You are not the owner');
            let mut contents = self.content.read();
            contents.from_array(@content);
            self.title.write(title);
            self.owner.write(owner);
            self.file_extension.write(file_extension);
        }

        fn read_content(self: @ContractState) -> Array<felt252> {
            self.content.read().array()
        }

        fn read_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn gift(ref self: ContractState, new_owner: ContractAddress) {
            assert(get_caller_address() == self.owner.read(), 'You are not the owner');
            self.owner.write(new_owner);
        }

        fn read_title(self: @ContractState) -> felt252 {
            self.title.read()
        }

        fn read_caption(self: @ContractState) -> felt252 {
            self.caption.read()
        }

        fn write_caption(ref self: ContractState, new_caption: felt252) {
            assert(get_caller_address() == self.owner.read(), 'You are not the owner');
            self.caption.write(new_caption);
        }

        fn read_file_extension(self: @ContractState) -> felt252 {
            self.file_extension.read()
        }
    }
}
